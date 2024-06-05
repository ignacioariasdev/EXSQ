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

    func testResponseHandlingSuccess() async throws {
        let expectedModel = Model(appId: "test", url: "https://example.com", breeds: [])
        mockAPI.testData = [expectedModel]

        let response = try await api.decodeFromAPI(page: 1)
        XCTAssertEqual(response.first?.appId, expectedModel.appId, "Response handling should correctly parse the expected data.")
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
}
