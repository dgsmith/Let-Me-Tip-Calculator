//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit

public class TipCalculatorModel {
    
    var total: Double
    var taxPct: Double
    var subtotal: Double {
        get {
            return total / (taxPct + 1)
        }
    }
    var taxAmt: Double {
        get {
            return taxPct * subtotal
        }
    }
    
    init(total: Double, taxPct: Double) {
        self.total = total
        self.taxPct = taxPct
    }
    
    convenience init() {
        self.init(total: 0.0, taxPct: 0.0)
    }
    
    func calculateExactTipWithTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double) {
        let tipAmt = subtotal * tipPct
        let finalTotal = total + tipAmt
        return (tipAmt, finalTotal)
    }
    
    func calculateRoundedTotalFromTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWithTipPercentage(tipPct)
        let newTotal = round(intermediateValue.finalTotal)
        let newTipAmt = newTotal - (subtotal * (1 + taxPct))
        let newTipPct = newTipAmt / subtotal
        return (newTipAmt, newTotal, newTipPct)
    }
    
    func calculateRoundedTipAmountFromTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWithTipPercentage(tipPct)
        let newTipAmt = round(intermediateValue.tipAmount)
        let newTotal = newTipAmt + (subtotal * (1 + taxPct))
        let newTipPct = newTipAmt / subtotal
        return (newTipAmt, newTotal, newTipPct)
    }
    
}
