//
//  TipData.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/16/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import UIKit

class TipData {
    
    ///Calculated
    var subtotal: DollarAmount {
        get {
            return DollarAmount(value: receiptTotal.value / (taxPercentage.value + 1))
        }
    }
    
    var taxPercentage: TaxPercentage {
        didSet {
            tipCalc.taxPct = taxPercentage.value
        }
    }
    
    /// Calculated
    var taxAmount: DollarAmount {
        get {
            return DollarAmount(value: taxPercentage.value * subtotal.value)
        }
    }
    
    /// Total on the receipt after taxes, but before tip
    var receiptTotal: DollarAmount {
        didSet {
            tipCalc.total = receiptTotal.value
        }
    }
    
    var tipPercentage: TipPercentage
    
    /// Calculated
    var tipAmount: DollarAmount {
        get {
            return DollarAmount(value: tipPercentage.value * subtotal.value)
        }
    }
    
    /// Total after tip
    var finalTotal = DollarAmount(value: 0.0)
    
    var calculationMethod: CalculationMethod = .NoRounding
    
    private let tipCalc = TipCalculatorModel()
    
    private let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    private let receiptTotalKey         = "receiptTotal"
    private let taxPercentageKey        = "taxPercentage"
    private let tipPercentageKey        = "tipPercentage"
    private let calculationMethodKey    = "calculationMethod"
    
    init() {
        if let encodedData = defaults.objectForKey("data") as? NSData,
            let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(encodedData) as? Dictionary<String,AnyObject> {
            if let inReceiptTotal = dictionary[receiptTotalKey] as? DollarAmount,
                let inTaxPercentage = dictionary[taxPercentageKey] as? TaxPercentage,
                let inTipPercentage = dictionary[tipPercentageKey] as? TipPercentage,
                let inCalculationMethodRaw = dictionary[calculationMethodKey] as? String,
                let inCalculationMethod = CalculationMethod(rawValue: inCalculationMethodRaw)
            {
                // We have values stored!
                taxPercentage = inTaxPercentage
                receiptTotal = inReceiptTotal
                tipPercentage = inTipPercentage
                calculationMethod = inCalculationMethod
                
                tipCalc.taxPct = taxPercentage.value
                tipCalc.total = receiptTotal.value
                
                calculate()
            } else {
                print("Error parsing dictionary")
                // No values! default init
                taxPercentage = TaxPercentage(value: 0.06)
                receiptTotal = DollarAmount(value: 32.78)
                tipPercentage = TipPercentage(value: 0.15)
                calculationMethod = .NoRounding
                
                tipCalc.taxPct = taxPercentage.value
                tipCalc.total = receiptTotal.value
                
                calculate()
            }
        } else {
            print("No defaults")
            // No values! default init
            taxPercentage = TaxPercentage(value: 0.06)
            receiptTotal = DollarAmount(value: 32.78)
            tipPercentage = TipPercentage(value: 0.15)
            calculationMethod = .NoRounding
            
            tipCalc.taxPct = taxPercentage.value
            tipCalc.total = receiptTotal.value
            
            calculate()
        }
        
    }
    
    func updateDataWithReceiptTotal(receiptTotal: DollarAmount, taxPercentage: TaxPercentage, andTipPercentage tipPercentage: TipPercentage) throws {
        guard receiptTotal.text != nil else { throw TipCalculationError.ReceiptParseError }
        guard taxPercentage.text != nil else { throw TipCalculationError.TaxParseError }
        guard tipPercentage.text != nil else { throw TipCalculationError.TipParseError }
        
        self.taxPercentage = taxPercentage
        self.receiptTotal = receiptTotal
        self.tipPercentage = tipPercentage
        
        calculate()
    }
    
    func calculate() {
        switch calculationMethod {
        case .NoRounding:
            (_, finalTotal.value) = tipCalc.calculateExactTipWithTipPercentage(tipPercentage.value)
        case .RoundedTip:
            (_, finalTotal.value, tipPercentage.value) = tipCalc.calculateRoundedTipAmountFromTipPercentage(tipPercentage.value)
        case .RoundedTotal:
            (_, finalTotal.value, tipPercentage.value) = tipCalc.calculateRoundedTotalFromTipPercentage(tipPercentage.value)
        }
    }
    
    func saveData() {
        let dictionary = [receiptTotalKey: receiptTotal,
                          taxPercentageKey: taxPercentage,
                          tipPercentageKey: tipPercentage,
                          calculationMethodKey: calculationMethod.rawValue]
        let encodedDictionary = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        defaults.setObject(encodedDictionary, forKey: "data")
        defaults.synchronize()
    }
}
