//
//  TipData.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/16/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import UIKit

struct DollarAmount {
    var value: Double {
        didSet {
            text = numberFormatter.stringFromNumber(value)
        }
    }
    private let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    private(set) var text: String?
    
    init(value: Double) {
        self.value = value
    }
}

struct TaxPercentage {
    var value: Double {
        didSet {
            text = taxFormatter.stringFromNumber(value)
        }
    }
    private let taxFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    private(set) var text: String?
    
    init(value: Double) {
        self.value = value
    }
}

struct TipPercentage {
    var value: Double {
        didSet {
            text = tipFormatter.stringFromNumber(value)
        }
    }
    private let tipFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    private(set) var text: String?
    
    init(value: Double) {
        self.value = value
    }
}

enum CalculationMethod {
    case NoRounding
    case RoundedTotal
    case RoundedTip
}

class TipData: NSObject {
    
    ///Calculated
    var subtotal: DollarAmount {
        get {
            return DollarAmount(value: receiptTotal.value / (taxPercentage.value + 1))
        }
    }
    
    var taxPercentage: TaxPercentage
    
    /// Calculated
    var taxAmount: DollarAmount {
        get {
            return DollarAmount(value: taxPercentage.value * subtotal.value)
        }
    }
    
    /// Total on the receipt after taxes, but before tip
    var receiptTotal: DollarAmount
    
    var tipPercentage: TipPercentage
    
    /// Calculated
    var tipAmount: DollarAmount {
        get {
            return DollarAmount(value: tipPercentage.value * receiptTotal.value)
        }
    }
    
    /// Total after tip
    var finalTotal: DollarAmount
    
    var calculationMethod: CalculationMethod = .NoRounding
    
    let tipCalc: TipCalculatorModel
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    let receiptTotalKey         = "receiptTotal"
    let taxPercentageKey        = "taxPercentage"
    let tipPercentageKey        = "tipPercentage"
    let finalTotalKey           = "finalTotal"
    let calculationMethodKey    = "calculationMethod"
    
    init(receiptTotal: Double, taxPercentage: Double) {
        if let inReceiptTotal = defaults.objectForKey(receiptTotalKey) as? DollarAmount,
            let inTaxPercentage = defaults.objectForKey(taxPercentageKey) as? TaxPercentage,
            let inTipPercentage = defaults.objectForKey(tipPercentageKey) as? TipPercentage {
            
        }
    }
}
