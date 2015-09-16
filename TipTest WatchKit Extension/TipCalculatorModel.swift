//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import Foundation

public class TipCalculatorModel {
    
    public var receiptTotal: Double
    public var taxPct: Double
    public var subtotal: Double {
        get {
            return receiptTotal / (taxPct + 1)
        }
    }
    public var taxAmt: Double {
        get {
            return taxPct * subtotal
        }
    }
    public var tipAmt: Double
    public var tipPct: Double
    public var total: Double
    
//    public init() {
//        self.receiptTotal  = 0
//        self.taxPct = 0
//        self.tipAmt = 0
//        self.tipPct = 0
//        self.total = 0
//    }
    
    public init(total:Double, taxPct:Double) {
        self.receiptTotal = total
        self.taxPct = taxPct
        self.tipAmt = 0
        self.tipPct = 0.15
        self.total = 0
    }
    
    public func calcTipWith(TipPct tipPct:Double) -> (tipAmt:Double, total:Double) {
        self.tipPct = tipPct
        self.tipAmt = subtotal * self.tipPct
        self.total = receiptTotal + tipAmt
        return (self.tipAmt, self.total)
    }
    
    public func calcRoundedTotalFrom(TipPct newTipPct:Double) -> (tipAmt:Double, total:Double, tipPct:Double) {
        self.tipPct = newTipPct
        let intermediateValue = calcTipWith(TipPct: self.tipPct)
        self.total = round(intermediateValue.total)
        self.tipAmt = self.total - (self.subtotal * (1 + self.taxPct))
        self.tipPct = self.tipAmt / self.subtotal
        return (self.tipAmt, self.total, self.tipPct)
    }
    
    public func calcRoundedTipFrom(TipPct newTipPct:Double) -> (tipAmt:Double, total:Double, tipPct:Double) {
        self.tipPct = newTipPct
        let intermediateValue = calcTipWith(TipPct: self.tipPct)
        self.tipAmt = round(intermediateValue.tipAmt)
        self.total = self.tipAmt + (self.subtotal * (1 + self.taxPct))
        self.tipPct = self.tipAmt / self.subtotal
        return (self.tipAmt, self.total, self.tipPct)
    }
    
}
