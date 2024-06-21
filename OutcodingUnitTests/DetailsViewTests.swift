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
        let expectedUrl = URL(string: "www.example.com")
        let expectedOrigin = "US"
        let expectedLifeSpan = "15-20"
        let expectedAffectionLevel = 5

        // When
        let detailsView = DetailsView(imageUrl: expectedUrl!, title: expectedTitle, description: expectedDescription, origin: expectedOrigin, lifeSpan: expectedLifeSpan, affectionLevel: expectedAffectionLevel )

        // Then
        XCTAssertEqual(detailsView.title, expectedTitle, "DetailsView should store the correct title.")
        XCTAssertEqual(detailsView.description, expectedDescription, "DetailsView should store the correct description.")
        
        XCTAssertEqual(detailsView.imageUrl, expectedUrl, "DetailsView should store the correct url.")
        XCTAssertEqual(detailsView.origin, expectedOrigin, "DetailsView should store the correct origin.")
        XCTAssertEqual(detailsView.lifeSpan, expectedLifeSpan, "DetailsView should store the correct life span.")
        XCTAssertEqual(detailsView.affectionLevel, expectedAffectionLevel, "DetailsView should store the correct affection level.")
    }

}
