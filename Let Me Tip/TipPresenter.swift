//
//  TipPresenter.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 6/24/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import Foundation

final class TipPresenter: TipViewPresenter {
    
    private static let sharedSingleton = TipPresenter()
    
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
    
    func update(withInputs data: [String:AnyObject]?,
                withCompletion completion: ([String:AnyObject]) -> Void) {
        
        var dataRead = false
        if let data = data {
            #if DEBUG
                print(data)
            #endif
            if let receiptTotal = data["receiptTotal"] as? Double,
                receiptTotal != tipCalculatorModel.receiptTotal {
                
                tipCalculatorModel.receiptTotal = receiptTotal
                dataRead = true
            }
            if let taxPercentage = data["taxPercentage"] as? Double,
                taxPercentage != tipCalculatorModel.taxPercentage {
                
                tipCalculatorModel.taxPercentage = taxPercentage
                dataRead = true
            }
            if let tipPercentage = data["tipPercentage"] as? Double,
                tipPercentage != tipCalculatorModel.tipPercentage {
                
                tipCalculatorModel.tipPercentage = tipPercentage
                dataRead = true
            }
            if let calculationMethodRaw = data["calculationMethod"] as? Int,
                let calculationMethod = TipCalculationMethod(rawValue: calculationMethodRaw),
                calculationMethod != tipCalculatorModel.calculationMethod {
                
                tipCalculatorModel.calculationMethod = calculationMethod
                dataRead = true
            }
        }
        
        let output = dataRead ? tipCalculatorModel.calculate() : tipCalculatorModel.propertyListRepresentation()
        #if DEBUG
            print(output)
        #endif
        completion(output)
    }
}
