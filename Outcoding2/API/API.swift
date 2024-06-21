//
//  API.swift
//  Outcoding2
//
//  Created by Ignacio Arias on 2024-06-03.
//

import Foundation

protocol APIProtocol {
    func buildUrl(page: Int) throws -> URL
    func decodeFromAPI(page: Int) async throws -> [Model]
}

/// Int is used for the HttpStatusCode
enum APIError: Error {
    case invalidUrl
    case invalidPage
    case invalidDecoding(Int, Error)
    case invalidResponse
    case redirectionFound(Int)
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)
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
        print("Complete url: \(completeUrl)")
        return completeUrl
    }
    
    func decodeFromAPI(page: Int) async throws -> [Model] {
        do {
            let (data, response) = try await URLSession.shared.data(from: buildUrl(page: page))
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode([Model].self, from: data)
                } catch {
                    print("Decoding error: \(error)")
                    throw APIError.invalidDecoding(httpResponse.statusCode, error)
                }
            case 300...399:
                throw APIError.redirectionFound(httpResponse.statusCode)
            case 400...499:
                throw APIError.clientError(httpResponse.statusCode)
            case 500...599:
                throw APIError.serverError(httpResponse.statusCode)
            default:
                throw APIError.unexpectedStatusCode(httpResponse.statusCode)
            }
        } catch {
            print("Failed with error: \(error)")
            throw error
        }
    }
}
