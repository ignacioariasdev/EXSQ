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
    case invalidDecoding
    case invalidPage
}

struct API: APIProtocol {
    func buildUrl(page: Int) throws -> URL {
        guard let rootUrl = URL(string: "https://api.thecatapi.com") else { throw APIError.invalidUrl }

        if page < 1 { throw APIError.invalidPage }
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
            let (data, _) = try await URLSession.shared.data(from: buildUrl(page: page))
            return try JSONDecoder().decode([Model].self, from: data)
        } catch {
            print("error Decoding Error: \(error.localizedDescription)")
            throw APIError.invalidDecoding
        }
    }
}
