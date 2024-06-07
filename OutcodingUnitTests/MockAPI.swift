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
    var testDataTypeB: Data?
    var httpResponse: HTTPURLResponse?
    var rawData: Data?  // Optional raw data to use for specific tests
    var mockStatusCode: Int = 200  // Default to 200 for general cases

    func buildUrl(page: Int) throws -> URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=100&has_breeds=1&page=\(page)") else {
            throw APIError.invalidUrl
        }
        return url
    }

    func decodeFromAPI(page: Int) async throws -> [Model] {
        if let response = httpResponse ?? HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!,
                                                          statusCode: mockStatusCode, // Default status code
                                                          httpVersion: "HTTP/1.1",
                                                          headerFields: nil) {

            let dataToUse = rawData ?? Data()  // Use provided raw data or default empty data
            switch response.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode([Model].self, from: dataToUse)
                } catch {
                    throw APIError.invalidDecoding(response.statusCode, error)
                }
            case 300...399:
                throw APIError.redirectionFound(response.statusCode)
            case 400...499:
                throw APIError.clientError(response.statusCode)
            case 500...599:
                throw APIError.serverError(response.statusCode)
            default:
                throw APIError.unexpectedStatusCode(response.statusCode)
            }

        } else  if shouldReturnError {
            throw APIError.invalidResponse
        } else {
            return testData
        }
    }
}
