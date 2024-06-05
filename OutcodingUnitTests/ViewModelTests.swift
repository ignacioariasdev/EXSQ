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

    func testPaginationHandling() async throws {
        // Setup initial state
        mockAPI.testData = [Model(appId: "1", url: "https://example.com", breeds: [])] // Fill with expected test data
        try await viewModel.updateList(page: 1)

        // Simulate user reaching the last item triggering pagination
        let lastItem = viewModel.listMain.last!
        try await viewModel.didDisplayedLastItem(item: lastItem)

        // Expect page increment after last item is displayed
        XCTAssertEqual(viewModel.currentPage, 2, "Current page should increment after last item is displayed.")
    }

    func testDataLoadingSuccess() async throws {
        // Setup test environment
        mockAPI.testData = [Model(appId: "1", url: "https://example.com", breeds: [])]  // Mock response data

        try await viewModel.updateList(page: 1)  // Trigger the data loading

        // Check if data was loaded into the view model
        XCTAssertFalse(viewModel.listMain.isEmpty, "List should not be empty after data is loaded.")
        XCTAssertEqual(viewModel.listMain.first?.appId, "1", "The loaded data's appId should match the mocked data's appId.")
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

}

