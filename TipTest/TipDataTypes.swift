//
//  TipDataTypes.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/16/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import UIKit

final class DollarAmount: NSObject, NSCoding {
    var value: Double
    private let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var text: String? {
        get {
            return numberFormatter.stringFromNumber(value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = numberFormatter.numberFromString(string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDoubleForKey("value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(value, forKey: "value")
    }
}

final class TaxPercentage: NSObject, NSCoding {
    var value: Double
    private let taxFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    var text: String? {
        get {
            return taxFormatter.stringFromNumber(value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = taxFormatter.numberFromString(string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDoubleForKey("value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(value, forKey: "value")
    }
}

final class TipPercentage: NSObject, NSCoding {
    var value: Double
    private let tipFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var text: String? {
        get {
            return tipFormatter.stringFromNumber(value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = tipFormatter.numberFromString(string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDoubleForKey("value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeDouble(value, forKey: "value")
    }
}

enum CalculationMethod: String {
    case NoRounding = "NoRounding"
    case RoundedTotal = "RoundedTotal"
    case RoundedTip = "RoundedTip"
}

enum TipCalculationError: ErrorType {
    case ReceiptParseError
    case TaxParseError
    case TipParseError
}
