//
//  APIServiceTests.swift
//  OutcodingUnitTests
//
//  Created by Ignacio Arias on 2024-06-05.
//

import XCTest
@testable import Outcoding2

final class APIServiceTests: XCTestCase {
    var api: APIProtocol!  // Use the protocol type here for flexibility
    var mockAPI: MockAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPI = MockAPI()
        api = mockAPI  // Inject the mock API
    }

    override func tearDownWithError() throws {
        api = nil
        mockAPI = nil
        try super.tearDownWithError()
    }


    func testRealUrlBuilding() throws {
        // Ensure we are testing the real API's URL construction
        let realApi = API()
        let url = try realApi.buildUrl(page: 20)
        XCTAssertEqual(url.absoluteString, "https://api.thecatapi.com/v1/images/search?api_key=live_TDxkreHiUYdSJTik1dbGMJe8ahwh8DAitDgQyQa0d4BsOfIOwfnLtm5KCJMCUpFE&limit=100&has_breeds=1&page=20", "URL should be correctly formed.")
    }

    func testResponseHandlingInvalidDecoding() async throws {
        // Setup the MockAPI to provide corrupted JSON
        let corruptedData = Data("corrupted JSON".utf8)
        mockAPI.rawData = corruptedData
        mockAPI.mockStatusCode = 200  // Simulating a successful HTTP status with bad content

        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Expected invalidDecoding error was not thrown")
        } catch APIError.invalidDecoding(let statusCode, let error) {
            XCTAssertEqual(statusCode, 200, "Status code should be 200 for this test case.")
            XCTAssertNotNil(error, "Error should not be nil.")
        } catch {
            XCTFail("Unexpected error type was thrown: \(error)")
        }
    }

    func testResponseHandlingSuccess() async throws {
        // Prepare expected model data
        let expectedModel = Model(appId: "test", url: "https://example.com", breeds: [
            ModelResults(appId: "breedId", name: "BreedName", description: "A cat breed.")
        ])
        let jsonData = try JSONEncoder().encode([expectedModel])
        mockAPI.rawData = jsonData // Set the raw JSON data to be returned by the mock API
        mockAPI.mockStatusCode = 200

        let models = try await mockAPI.decodeFromAPI(page: 1)
        XCTAssertEqual(models.first?.appId, expectedModel.appId, "Response handling should correctly parse the expected data.")
    }


    func testResponseHandlingFailure() async throws {
        mockAPI.shouldReturnError = true
        do {
            _ = try await api.decodeFromAPI(page: 1)
            XCTFail("Should throw error when decoding fails")
        } catch {
            // Error is expected here, so the test should pass without additional handling.
        }
    }

    func testHTTPRedirectionHandling() async throws {
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 301, httpVersion: nil, headerFields: nil)
        do {
            _ = try await api.decodeFromAPI(page: 1)
            XCTFail("Should throw redirection error for HTTP 301")
        } catch APIError.redirectionFound(let statusCode) {
            XCTAssertEqual(statusCode, 301)
        }
    }

    func testHTTPClientErrorHandling() async throws {
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        do {
            _ = try await api.decodeFromAPI(page: 1)
            XCTFail("Should throw client error for HTTP 404")
        } catch APIError.clientError(let statusCode) {
            XCTAssertEqual(statusCode, 404)
        }
    }

    func testHTTPServerErrorHandling() async throws {
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        do {
            _ = try await api.decodeFromAPI(page: 1)
            XCTFail("Should throw server error for HTTP 500")
        } catch APIError.serverError(let statusCode) {
            XCTAssertEqual(statusCode, 500)
        }
    }

    func testInvalidDataDecoding() async throws {
        let corruptedData = Data("{Name}".utf8)
        mockAPI.rawData = corruptedData
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Should throw decoding error for corrupted data")
        } catch let error as APIError {
            switch error {
            case .invalidDecoding(let statusCode, let decodeError):
                XCTAssertEqual(statusCode, 200, "Status code should be 200 for decoding errors.")
                print("Decoding error: \(decodeError.localizedDescription)")
            default:
                XCTFail("Unexpected error type: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRedirectionHandling() async throws {
        mockAPI.mockStatusCode = 301
        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Should have thrown an error for HTTP 301")
        } catch APIError.redirectionFound(let statusCode) {
            XCTAssertEqual(statusCode, 301)
        }
    }

    func testClientErrorHandling() async throws {
        mockAPI.mockStatusCode = 404
        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Should have thrown an error for HTTP 404")
        } catch APIError.clientError(let statusCode) {
            XCTAssertEqual(statusCode, 404)
        }
    }

    func testServerErrorHandling() async throws {
        mockAPI.mockStatusCode = 500
        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Should have thrown an error for HTTP 500")
        } catch APIError.serverError(let statusCode) {
            XCTAssertEqual(statusCode, 500)
        }
    }

    func testUnexpectedStatusCodeHandling() async throws {
        mockAPI.mockStatusCode = 600
        do {
            _ = try await mockAPI.decodeFromAPI(page: 1)
            XCTFail("Should have thrown an error for unexpected status code")
        } catch APIError.unexpectedStatusCode(let statusCode) {
            XCTAssertEqual(statusCode, 600)
        }
    }
}
