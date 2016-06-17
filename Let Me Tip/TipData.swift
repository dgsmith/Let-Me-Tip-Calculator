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
            tipCalc.taxPercentage = taxPercentage.value
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
            tipCalc.receiptTotal = receiptTotal.value
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
    
    private let defaults = UserDefaults(suiteName: "group.Let-Me-Tip")!
    private let receiptTotalKey         = "receiptTotal"
    private let taxPercentageKey        = "taxPercentage"
    private let tipPercentageKey        = "tipPercentage"
    private let calculationMethodKey    = "calculationMethod"
    
    init() {
        if let encodedData = defaults.object(forKey: "data") as? Data,
            let dictionary = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? Dictionary<String,AnyObject> {
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
                
                tipCalc.taxPercentage = taxPercentage.value
                tipCalc.receiptTotal = receiptTotal.value
                
                calculate()
            } else {
                print("Error parsing dictionary")
                // No values! default init
                taxPercentage = TaxPercentage(value: 0.06)
                receiptTotal = DollarAmount(value: 32.78)
                tipPercentage = TipPercentage(value: 0.15)
                calculationMethod = .NoRounding
                
                tipCalc.taxPercentage = taxPercentage.value
                tipCalc.receiptTotal = receiptTotal.value
                
                calculate()
            }
        } else {
            print("No defaults")
            // No values! default init
            taxPercentage = TaxPercentage(value: 0.06)
            receiptTotal = DollarAmount(value: 32.78)
            tipPercentage = TipPercentage(value: 0.15)
            calculationMethod = .NoRounding
            
            tipCalc.taxPercentage = taxPercentage.value
            tipCalc.receiptTotal = receiptTotal.value
            
            calculate()
        }
        
    }
    
    func updateDataWithReceiptTotal(_ receiptTotal: DollarAmount, taxPercentage: TaxPercentage, andTipPercentage tipPercentage: TipPercentage) throws {
        guard receiptTotal.text != nil else { throw TipCalculationError.receiptParseError }
        guard taxPercentage.text != nil else { throw TipCalculationError.taxParseError }
        guard tipPercentage.text != nil else { throw TipCalculationError.tipParseError }
        
        self.taxPercentage = taxPercentage
        self.receiptTotal = receiptTotal
        self.tipPercentage = tipPercentage
        
        calculate()
    }
    
    func calculate() {
        switch calculationMethod {
        case .NoRounding:
            (_, finalTotal.value) = tipCalc.calculateExactTipWith(tipPercentage: tipPercentage.value)
        case .RoundedTip:
            (_, finalTotal.value, tipPercentage.value) = tipCalc.calculateRoundedTipAmountWith(tipPercentage: tipPercentage.value)
        case .RoundedTotal:
            (_, finalTotal.value, tipPercentage.value) = tipCalc.calculateRoundedTotalWith(tipPercentage: tipPercentage.value)
        }
    }
    
    func saveData() {
        let dictionary = [receiptTotalKey: receiptTotal,
                          taxPercentageKey: taxPercentage,
                          tipPercentageKey: tipPercentage,
                          calculationMethodKey: calculationMethod.rawValue]
        let encodedDictionary = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        defaults.set(encodedDictionary, forKey: "data")
        defaults.synchronize()
    }
}
