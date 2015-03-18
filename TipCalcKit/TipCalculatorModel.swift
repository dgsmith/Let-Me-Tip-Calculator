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
    
    public func returnExactPossibleTips() -> [Int: (tipAmt:Double, total:Double)] {
        
        let possibleTips = [0.12, 0.15, 0.18]
        
        var retval = Dictionary<Int, (tipAmt:Double, total:Double)>()
        for possibleTip in possibleTips {
            let intPct = Int(possibleTip * 100)
            retval[intPct] = calcTipWith(TipPct: possibleTip)
        }
        return retval
    }
    
    public func returnRoundedTotalPossibleTips() -> [Int: (tipAmt:Double, total:Double)] {
        
        let possibleTips = [0.12, 0.15, 0.18]
        
        var retval = Dictionary<Int, (tipAmt:Double, total:Double)>()
        for possibleTip in possibleTips {
            let intermediateValue = calcTipWith(TipPct: possibleTip)
            let newTotal = round(intermediateValue.total)
            let newTipAmt = newTotal - (subtotal * (1 + taxPct))
            let newTipPct = newTipAmt / subtotal
            let intPct = Int(round(newTipPct * 100))
            retval[intPct] = (newTipAmt, newTotal)
            
        }
        return retval
    }
    
    public func returnRoundedTipPossibleTips() -> [Int: (tipAmt:Double, total:Double)] {
        let possibleTips = [0.12, 0.15, 0.18]
        
        var retval = Dictionary<Int, (tipAmt:Double, total:Double)>()
        for possibleTip in possibleTips {
            let intermediateValue = calcTipWith(TipPct: possibleTip)
            let newTipAmt = round(intermediateValue.tipAmt)
            let newTotal = newTipAmt + (subtotal * (1 + taxPct))
            let newTipPct = newTipAmt / subtotal
            let intTipPct = Int(round(newTipPct * 100))
            retval[intTipPct] = (newTipAmt, newTotal)
        }
        return retval
    }
}
