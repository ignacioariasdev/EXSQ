//
//  MockAPI.swift
//  OutcodingUnitTests
//
//  Created by Ignacio Arias on 2024-06-05.
//

import XCTest
@testable import Outcoding2

class MockAPI: APIProtocol {
    var shouldReturnError = false
    var testData: [Model] = []

    func buildUrl(page: Int) throws -> URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=100&has_breeds=1&page=\(page)") else {
            throw APIError.invalidUrl
        }
        return url
    }

    func decodeFromAPI(page: Int) async throws -> [Model] {
        if shouldReturnError {
            throw APIError.invalidDecoding // Ensure this error is defined and can be thrown
        }
        return testData
    }

}
