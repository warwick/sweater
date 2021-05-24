//
//  SweaterUITests.swift
//  SweaterUITests
//
//  Created by Bob Warwick on 2021-05-22.
//

import XCTest

class SweaterUITests: XCTestCase {

    override func setUpWithError() throws {

        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCorrectNumberOfDots() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        let indicatorValue = app.pageIndicators.firstMatch.value as? String
        XCTAssert(indicatorValue == "page 1 of 3", "There page indicator was in an unexpected state")

    }
    
    func testAddNewLocation() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        app.buttons.firstMatch.tap() // Tap on the plus button.  There's only one button right now, so it's an easy find.
        
        let searchField = app.searchFields.firstMatch
        XCTAssertNotNil(searchField, "The search field was not found")
        
        searchField.tap()
        searchField.typeText("Fredericton")
        
        let firstResult = app.tables.cells.firstMatch
        firstResult.tap()
        
        sleep(3) // Give it more than enough time to actually add the new location
        
        let indicatorValue = app.pageIndicators.firstMatch.value as? String
        XCTAssert(indicatorValue == "page 4 of 4", "There page indicator was in an unexpected state")
        
    }
    
    func testDeleteLocation() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        app.collectionViews.firstMatch.swipeLeft()
        app.collectionViews.firstMatch.swipeLeft()
        
        var indicatorValue = app.pageIndicators.firstMatch.value as? String
        XCTAssert(indicatorValue == "page 3 of 3", "There page indicator was in an unexpected state")

        let deleteButton = app.collectionViews.cells.firstMatch.buttons.firstMatch
        deleteButton.tap()
        
        sleep(1) // Give it more than enough time to delete
        
        indicatorValue = app.pageIndicators.firstMatch.value as? String
        XCTAssert(indicatorValue == "page 2 of 2", "There page indicator was in an unexpected state")

    }
    
    func testShowDetails() throws {
        
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()

        app.collectionViews.firstMatch.swipeLeft()

        let locationCell = app.collectionViews.cells.firstMatch
        locationCell.tap()
        
        let locationLabel = app.staticTexts["Vancouver"]
        XCTAssertNotNil(locationLabel)
        
    }

}
