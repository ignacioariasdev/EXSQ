//
//  OutcodingUITests.swift
//  OutcodingUITests
//
//  Created by Ignacio Arias on 2024-06-05.
//

import XCTest

class OutcodingUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testNavigationToListDetail() {        
        // Start the test by making sure the app is ready and the list appears
        let breedsList = app.collectionViews["BreedsList"]
        XCTAssertTrue(breedsList.waitForExistence(timeout: 10), "The breeds list should exist.")

        // Tap the first row in the list
        let firstRow = breedsList.cells.firstMatch // We use firstMatch to simply select the first cell
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5), "The first row should be present.")
        firstRow.tap()
    }

    func testNavigationToListScroll() {
        let breedsList = app.collectionViews["BreedsList"]
        XCTAssertTrue(breedsList.waitForExistence(timeout: 10), "The breeds list should exist.")
    }
}

