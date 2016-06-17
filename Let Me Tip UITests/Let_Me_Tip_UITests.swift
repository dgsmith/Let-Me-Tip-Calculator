//
//  Let_Me_Tip_UITests.swift
//  Let Me Tip UITests
//
//  Created by Grayson Smith on 5/6/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import XCTest

class Let_Me_Tip_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
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
    
    func testVerify() {
        
    }
    
}
