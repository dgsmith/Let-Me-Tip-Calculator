//
//  TipPresenter.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 6/24/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import Foundation

final class TipPresenter: TipViewPresenter {
    
    fileprivate static let sharedSingleton = TipPresenter()
    
    class func shared() -> TipViewPresenter {
        return sharedSingleton
    }
    
    /// Value of TipCalculatorModel
    var tipCalculatorModel: TipCalculatorModel
    
    required init(tipCalculatorModel: TipCalculatorModel) {
        self.tipCalculatorModel = tipCalculatorModel
    }
    
    convenience init() {
        if let defaults = UserDefaults(suiteName: "group.Let-Me-Tip"),
            let tipData = defaults.object(forKey: "tipData") as? [String:AnyObject],
            let model = TipCalculatorModel(propertyListRepresentation: tipData) {
            self.init(tipCalculatorModel: model)
        } else {
            let model = TipCalculatorModel(total: 32.78, tipPercentage: 0.18)
            self.init(tipCalculatorModel: model)
        }
    }
    
    func update(withInputs data: [String:AnyObject]? = nil,
                completion: (([String:AnyObject]) -> Void)? = nil) {
        
        var dataRead = false
        if let data = data {
            #if DEBUG
                print(data)
            #endif
            if let receiptTotal = data["receiptTotal"] as? NSNumber,
                receiptTotal.doubleValue != tipCalculatorModel.receiptTotal {
                
                tipCalculatorModel.receiptTotal = receiptTotal.doubleValue
                dataRead = true
            }
            if let taxPercentage = data["taxPercentage"] as? NSNumber,
                taxPercentage.doubleValue != tipCalculatorModel.taxPercentage {
                
                tipCalculatorModel.taxPercentage = taxPercentage.doubleValue
                dataRead = true
            }
            if let taxAmount = data["taxAmount"] as? NSNumber,
                taxAmount.doubleValue != tipCalculatorModel.taxAmount {
                
                tipCalculatorModel.taxAmount = taxAmount.doubleValue
                dataRead = true
            }
            if let tipPercentage = data["tipPercentage"] as? NSNumber,
                tipPercentage.doubleValue != tipCalculatorModel.tipPercentage {
                
                tipCalculatorModel.tipPercentage = tipPercentage.doubleValue
                dataRead = true
            }
            if let calculationMethodRaw = data["calculationMethod"] as? NSNumber,
                let calculationMethod = TipCalculationMethod(rawValue: calculationMethodRaw.intValue),
                calculationMethod != tipCalculatorModel.calculationMethod {
                
                tipCalculatorModel.calculationMethod = calculationMethod
                dataRead = true
            }
            if let taxInputMethodRaw = data["taxInputMethod"] as? NSNumber,
                let taxInputMethod = TaxInputMethod(rawValue: taxInputMethodRaw.intValue),
                taxInputMethod != tipCalculatorModel.taxInputMethod {
                
                tipCalculatorModel.taxInputMethod = taxInputMethod
                dataRead = true
            }
        }
        
        let output = dataRead ? tipCalculatorModel.calculate() : tipCalculatorModel.propertyListRepresentation()
        #if DEBUG
            print(output)
        #endif
        completion?(output)
    }
}
