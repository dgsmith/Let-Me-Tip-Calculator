//
//  Let_Me_Tip_UITests.swift
//  Let Me Tip UITests
//
//  Created by Grayson Smith on 5/6/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import XCTest
//import Let_Me_Tip

class Let_Me_Tip_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
//        let app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        
//        let app = XCUIApplication()
//        
//        // First snapshot
//        snapshot("01NoRounding")
//        
//        app.buttons["Rounded Tip"].tap()
//        
//        // Second snapshot
//        snapshot("02RoundedTip")
//        
//        app.buttons["Rounded Total"].tap()
//        
//        // Third snapshot
//        snapshot("03RoundedTotal")
//        
//    }
    
//    class TestView: TipView {}
//    
//    func testBasic() {
//        let tipView = TestView()
//        var model = TipCalculatorModel()
//        model.calculationMethod = .noRounding
//        model.receiptTotal = 19.99
//        model.taxPercentage = 0
//        model.tipPercentage = 0.18
//        let data = model.calculate()
//        // 19.99 * 1.18 = 23.59
//        if let finalTotal = data["finalTotal"] as? NSNumber {
//            XCTAssertEqual(tipView.decimalFormatter.string(from: finalTotal) ?? "", "$23.59")
//        }
//    }
//    
//    func testTax() {
//        let tipView = TestView()
//        var model = TipCalculatorModel()
//        model.calculationMethod = .noRounding
//        model.receiptTotal = 19.99
//        model.taxPercentage = 0.1
//        model.tipPercentage = 0.18
//        let data = model.calculate()
//        // 19.99 + ((19.99 / (1 + 0.1)) * 0.18) = 23.26
//        if let finalTotal = data["finalTotal"] as? NSNumber {
//            XCTAssertEqual(tipView.decimalFormatter.string(from: finalTotal) ?? "", "$23.26")
//        }
//    }
    
}
