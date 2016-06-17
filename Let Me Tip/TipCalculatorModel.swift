//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit

public class TipCalculatorModel {
    
    var subtotal: Double {
        get {
            return receiptTotal / (taxPercentage + 1)
        }
    }
    var taxPercentage: Double
    var taxAmount: Double {
        get {
            return taxPercentage * subtotal
        }
    }
    var receiptTotal: Double
    var tipAmount: Double
    var tipPercentage: Double
    var finalTotal: Double
    
    init(total: Double, taxPercentage: Double) {
        receiptTotal = total
        self.taxPercentage = taxPercentage
        tipAmount = 0.0
        tipPercentage = 0.0
        finalTotal = 0.0
    }
    
    convenience init() {
        self.init(total: 0.0, taxPercentage: 0.0)
    }
    
    func calculateExactTipWith(tipPercentage tipPct: Double) -> (tipAmount: Double, finalTotal: Double) {
        tipAmount = subtotal * tipPct
        finalTotal = receiptTotal + tipAmount
        return (tipAmount, finalTotal)
    }
    
    func calculateRoundedTotalWith(tipPercentage tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWith(tipPercentage: tipPct)
        finalTotal = round(intermediateValue.finalTotal)
        tipAmount = finalTotal - (subtotal * (1 + taxPercentage))
        tipPercentage = tipAmount / subtotal
        return (tipAmount, finalTotal, tipPercentage)
    }
    
    func calculateRoundedTipAmountWith(tipPercentage tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWith(tipPercentage: tipPct)
        tipAmount = round(intermediateValue.tipAmount)
        finalTotal = tipAmount + (subtotal * (1 + taxPercentage))
        tipPercentage = tipAmount / subtotal
        return (tipAmount, finalTotal, tipPercentage)
    }
    
}
