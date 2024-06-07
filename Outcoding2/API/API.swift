//
//  API.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import Foundation

/*
 https://api.thecatapi.com/v1/images/search?api_key=live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE&limit=1&has_breeds=1

 -----------
 https://api.thecatapi.com/v1/images/search?api_key=live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE&limit=100&has_breeds=1&page=20

 --------

 https://api.thecatapi.com/v1/images/search?
 api_key=live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE
 &limit=100
 &has_breeds=1
 &page=20
 */

protocol APIProtocol {
    func buildUrl(page: Int) throws -> URL
    func decodeFromAPI(page: Int) async throws -> [Model]
}

enum APIError: Error {
    case invalidUrl
    case invalidPage
    case invalidDecoding(Int, Error) // httpStatusCode, Error
    case invalidResponse
    case redirectionFound(Int)
    case clientError(Int) // httpStatusCode
    case serverError(Int) // httpStatusCode
    case unexpectedStatusCode(Int) // Handle any other unexpected status codes
}

struct API: APIProtocol {
    func buildUrl(page: Int) throws -> URL {
        guard let rootUrl = URL(string: "https://api.thecatapi.com"), ["http", "https"].contains(rootUrl.scheme) else { throw APIError.invalidUrl }

        guard page >= 1 else { throw APIError.invalidPage }

        var urlComponents = URLComponents(url: rootUrl.appending(path: "/v1/images/search"), resolvingAgainstBaseURL: false)

        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: "live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE"),
            URLQueryItem(name: "limit", value: "100"),
            URLQueryItem(name: "has_breeds", value: "1"),
            URLQueryItem(name: "page", value: page.description)
        ]

        guard let completeUrl = urlComponents?.url else { throw APIError.invalidUrl }
        //        print("Complete url: \(completeUrl)")
        return completeUrl
    }

    func decodeFromAPI(page: Int) async throws -> [Model] {
        do {
            let (data, response) = try await URLSession.shared.data(from: buildUrl(page: page))

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse // Handle non-HTTP responses or casting failures
            }

            // Print the response code for diagnostic purposes
            print("HTTP Status Code: \(httpResponse.statusCode)")

            switch httpResponse.statusCode {
            case 200...299:
                // Handle successful responses
                do {
                    return try JSONDecoder().decode([Model].self, from: data)
                } catch {
                    // Decoding failed, throw a detailed error
                    print("Decoding error: \(error)")
                    throw APIError.invalidDecoding(httpResponse.statusCode, error)
                }
            case 300...399:
                // Handle redirections
                throw APIError.redirectionFound(httpResponse.statusCode)
            case 400...499:
                // Handle client errors
                throw APIError.clientError(httpResponse.statusCode)
            case 500...599:
                // Handle server errors
                throw APIError.serverError(httpResponse.statusCode)
            default:
                // Handle unexpected status codes
                throw APIError.unexpectedStatusCode(httpResponse.statusCode)
            }
        } catch {
            print("Failed with error: \(error)")
            throw error // Re-throw the caught error to be handled by the caller
        }
    }
}
