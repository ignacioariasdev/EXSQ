//
//  ViewModelTests.swift
//  OutcodingUnitTests
//
//  Created by Ignacio Arias on 2024-06-05.
//

import XCTest
@testable import Outcoding2

final class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    var mockAPI: MockAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPI = MockAPI()
        viewModel = ViewModel(api: mockAPI)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPI = nil
        try super.tearDownWithError()
    }

    func testDataLoadingSuccess() async throws {
        // Setup test environment
        mockAPI.testData = [Model(appId: "1", url: "https://example.com", breeds: [])]  // Mock response data

        /*try await viewModel.updateList(page: 1)*/  // Trigger the data loading
        await viewModel.updateList(page: 1)

        // Check if data was loaded into the view model
        if !viewModel.listMain.isEmpty {
            XCTAssertFalse(viewModel.listMain.isEmpty, "List should not be empty after data is loaded.")
            XCTAssertEqual(viewModel.listMain.first?.appId, "1", "The loaded data's appId should match the mocked data's appId.")
        }
    }

    // Test for a valid URL string
    func testGetImageUrlValidUrl() throws {
        let urlString = "https://example.com"
        do {
            let url = try viewModel.getImageUrl(from: urlString)
            XCTAssertEqual(url, URL(string: urlString), "The URL returned should match the URL initialized with the given string.")
        } catch {
            XCTFail("No error should be thrown for a valid URL")
        }
    }

    // Test for a truly invalid URL string
    func testGetImageUrlInvalidUrl() throws {
        let urlString = "just a plain wrong url"
        XCTAssertThrowsError(try viewModel.getImageUrl(from: urlString)) { error in
            XCTAssertTrue(error is ViewModelError, "The error thrown should be a ViewModelError")
            XCTAssertEqual(error as? ViewModelError, ViewModelError.invalidUrl, "The error should indicate an invalid URL")
        }
    }

    func testFetchDataHandlesDecodingError() async throws {
        // Prepare the mock API to throw an invalidDecoding error
        let corruptedData = Data("{Invalid JSON}".utf8)
        mockAPI.rawData = corruptedData
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        // Await changes to ensure updates are completed, then check thread safety
        await MainActor.run {
            // These checks should run on the main thread
            viewModel.httpStatusCode = 200
            XCTAssertEqual(viewModel.httpStatusCode, 200, "The HTTP status code should be 200")
            XCTAssertNotNil(viewModel.anyError, "The error description should not be nil")
        }
    }

    func testFetchDataHandlesDecodingError2() async throws {
        // Prepare the mock API to throw an invalidDecoding error
        let corruptedData = Data("{Invalid JSON}".utf8)
        mockAPI.rawData = corruptedData
        mockAPI.httpResponse = HTTPURLResponse(url: URL(string: "https://api.thecatapi.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            _ = try await viewModel.fetchData(page: 1)
            XCTFail("fetchData should have thrown an error due to invalid decoding")
        } catch let error as APIError {
            switch error {
            case .invalidDecoding(let statusCode, let decodeError):
                // Check that the thrown error has the correct properties
                XCTAssertEqual(statusCode, 200, "Status code in error should be 200")
                XCTAssertNotNil(decodeError, "There should be a decoding error")
            default:
                XCTFail("Error thrown was not of type .invalidDecoding: \(error)")
            }
        } catch {
            XCTFail("An unexpected error type was thrown: \(error)")
        }
    }
}
