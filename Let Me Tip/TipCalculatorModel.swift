//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit

struct TipCalculatorModel: PropertyListReadable {
    
    // User entered values
    var receiptTotal: Double
    var tipPercentage: Double
    var taxPercentage: Double
    var calculationMethod: TipCalculationMethod
    
    // Outputs
    var subtotal: Double {
        get {
            return receiptTotal / (taxPercentage + 1)
        }
    }
    var taxAmount: Double {
        get {
            return taxPercentage * subtotal
        }
    }
    
    var tipAmount: Double
    var finalTotal: Double
    
    private let defaults = UserDefaults(suiteName: "group.Let-Me-Tip")!
    
    init(total: Double, tipPercentage: Double) {
        self.receiptTotal       = total
        self.taxPercentage      = 0.0
        self.tipAmount          = 0.0
        self.tipPercentage      = tipPercentage
        self.finalTotal         = 0.0
        self.calculationMethod  = .noRounding
    }
    
    init() {
        self.init(total: 32.78, tipPercentage: 0.18)
    }
    
    init?(propertyListRepresentation: [String: AnyObject]?) {
        guard let dictionary = propertyListRepresentation else { return nil }
        if let receiptTotal = dictionary["receiptTotal"] as? NSNumber,
            let taxPercentage = dictionary["taxPercentage"] as? NSNumber,
            let tipPercentage = dictionary["tipPercentage"] as? NSNumber,
            let tipAmount = dictionary["tipAmount"] as? NSNumber,
            let finalTotal = dictionary["finalTotal"] as? NSNumber,
            let calculationMethod = dictionary["calculationMethod"] as? NSNumber {
            
            self.receiptTotal = receiptTotal.doubleValue
            self.taxPercentage = taxPercentage.doubleValue
            self.tipPercentage = tipPercentage.doubleValue
            self.tipAmount = tipAmount.doubleValue
            self.finalTotal = finalTotal.doubleValue
            self.calculationMethod = TipCalculationMethod(rawValue: calculationMethod.intValue)!
            
        } else {
            return nil
        }
    }
    
    mutating func calculate() -> [String: AnyObject] {
        switch calculationMethod {
        case .noRounding:
            // Directly calculate the tip amount and final total
            tipAmount = subtotal * tipPercentage
            finalTotal = receiptTotal + tipAmount
            
        case .roundedTip:
            // First calculate what the tip amount _would_ be,
            let rawTipAmount = subtotal * tipPercentage
            
            // then round it.
            tipAmount = round(rawTipAmount)
            
            // Now add up the final total,
            finalTotal = receiptTotal + tipAmount
            
            // and finish by updating the new tip  percentage.
            tipPercentage = tipAmount / subtotal
            
        case .roundedTotal:
            // First calculate what the final total _would_ be,
            let rawFinalTotal = (subtotal * tipPercentage) + receiptTotal
            
            // then round it.
            finalTotal = round(rawFinalTotal)
            
            // Now calculate what the tip becomes,
            tipAmount = finalTotal - receiptTotal
            
            // and update our new tip percentage
            tipPercentage = tipAmount / subtotal
        }
        return save()
    }
    
    func save() -> [String: AnyObject] {
        let tipData = propertyListRepresentation()
        defaults.set(tipData, forKey: "tipData")
        return tipData
    }
    
    func propertyListRepresentation() -> [String: AnyObject] {
        let representation: [String: AnyObject] = [
            "subtotal": NSNumber(value: subtotal),
            "taxPercentage": NSNumber(value: taxPercentage),
            "taxAmount": NSNumber(value: taxAmount),
            "receiptTotal": NSNumber(value: receiptTotal),
            "tipPercentage": NSNumber(value: tipPercentage),
            "tipAmount": NSNumber(value: tipAmount),
            "finalTotal": NSNumber(value: finalTotal),
            "calculationMethod": NSNumber(value: calculationMethod.rawValue)
        ]
        return representation
    }
    
}
