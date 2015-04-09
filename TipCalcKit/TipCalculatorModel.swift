//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import Foundation

public class TipCalculatorModel {
    
    public var total: Double
    public var taxPct: Double
    public var subtotal: Double {
        get {
            return total / (taxPct + 1)
        }
    }
    public var taxAmt: Double {
        get {
            return taxPct * subtotal
        }
    }
    
    public init() {
        self.total  = 0
        self.taxPct = 0
    }
    
    public init(total:Double, taxPct:Double) {
        self.total = total
        self.taxPct = taxPct
    }
    
    public func calcTipWith(TipPct tipPct:Double) -> (tipAmt:Double, total:Double) {
        let tipAmt = subtotal * tipPct
        let finalTotal = total + tipAmt
        return (tipAmt, finalTotal)
    }
    
    public func calcRoundedTotalFrom(TipPct tipPct:Double) -> (tipAmt:Double, total:Double, newTipPct:Double) {
        let intermediateValue = calcTipWith(TipPct: tipPct)
        let newTotal = round(intermediateValue.total)
        let newTipAmt = newTotal - (subtotal * (1 + taxPct))
        let newTipPct = newTipAmt / subtotal
        return (newTipAmt, newTotal, newTipPct)
    }
    
    public func calcRoundedTipFrom(TipPct tipPct:Double) -> (tipAmt:Double, total:Double, newTipPct:Double) {
        let intermediateValue = calcTipWith(TipPct: tipPct)
        let newTipAmt = round(intermediateValue.tipAmt)
        let newTotal = newTipAmt + (subtotal * (1 + taxPct))
        let newTipPct = newTipAmt / subtotal
        return (newTipAmt, newTotal, newTipPct)
    }
    
}
