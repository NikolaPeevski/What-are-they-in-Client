//
//  What_Are_They_InUITests.swift
//  What Are They InUITests
//
//  Created by Brandon Ching on 3/28/19.
//  Copyright © 2019 Brandon Ching. All rights reserved.
//

import XCTest

class What_Are_They_InUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testRetakePicture() {
        
        let app = XCUIApplication()
        let cameraButton = app.buttons["camera"]
        XCTAssertTrue(cameraButton.exists)
        cameraButton.tap()
        app.alerts["Would you like to use this picture?"].buttons["Retake"].tap()
        
        XCTAssertTrue(cameraButton.exists)
        cameraButton.tap()
        
    }
    
    func testUsePicture() {
        
        let app = XCUIApplication()
        app.buttons["camera"].tap()
        app.alerts["Would you like to use this picture?"].buttons["Yes"].tap()
        app.buttons["Button"].tap()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}
