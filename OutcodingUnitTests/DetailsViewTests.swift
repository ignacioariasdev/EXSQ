//
//  DetailsViewTests.swift
//  OutcodingUnitTests
//
//  Created by Ignacio Arias on 2024-06-07.
//

import XCTest
@testable import Outcoding2

final class DetailsViewTests: XCTestCase {

    func testDetailsViewInit() {
        // Given
        let expectedTitle = "Test Title"
        let expectedDescription = "Test Description"

        // When
        let detailsView = DetailsView(title: expectedTitle, description: expectedDescription)

        // Then
        XCTAssertEqual(detailsView.title, expectedTitle, "DetailsView should store the correct title.")
        XCTAssertEqual(detailsView.description, expectedDescription, "DetailsView should store the correct description.")
    }

}
