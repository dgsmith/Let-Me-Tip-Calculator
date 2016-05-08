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
            return receiptTotal / (taxPct + 1)
        }
    }
    var taxPct: Double
    var taxAmt: Double {
        get {
            return taxPct * subtotal
        }
    }
    var receiptTotal: Double
    var tipAmt: Double
    var tipPct: Double
    var finalTotal: Double
    
    init(total: Double, taxPct: Double) {
        receiptTotal = total
        self.taxPct = taxPct
        tipAmt = 0.0
        tipPct = 0.0
        finalTotal = 0.0
    }
    
    convenience init() {
        self.init(total: 0.0, taxPct: 0.0)
    }
    
    func calculateExactTipWithTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double) {
        tipAmt = subtotal * tipPct
        finalTotal = receiptTotal + tipAmt
        return (tipAmt, finalTotal)
    }
    
    func calculateRoundedTotalFromTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWithTipPercentage(tipPct)
        finalTotal = round(intermediateValue.finalTotal)
        tipAmt = finalTotal - (subtotal * (1 + taxPct))
        self.tipPct = tipAmt / subtotal
        return (tipAmt, finalTotal, self.tipPct)
    }
    
    func calculateRoundedTipAmountFromTipPercentage(tipPct: Double) -> (tipAmount: Double, finalTotal: Double, newTipPercentage: Double) {
        let intermediateValue = calculateExactTipWithTipPercentage(tipPct)
        tipAmt = round(intermediateValue.tipAmount)
        finalTotal = tipAmt + (subtotal * (1 + taxPct))
        self.tipPct = tipAmt / subtotal
        return (tipAmt, finalTotal, self.tipPct)
    }
    
}
