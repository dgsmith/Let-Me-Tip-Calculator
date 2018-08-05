//
//  Let_Me_TipUITests.swift
//  Let_Me_TipUITests
//
//  Created by Grayson Smith on 9/28/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import XCTest

class Let_Me_TipUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        // First snapshot
        snapshot("01NoRounding")
        
        app.buttons["Rounded Tip"].tap()
        
        // Second snapshot
        snapshot("02RoundedTip")
        
        app.buttons["Rounded Total"].tap()
        
        // Third snapshot
        snapshot("03RoundedTotal")
        
    }
    
}
