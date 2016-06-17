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
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var text: String? {
        get {
            return numberFormatter.string(from: value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = numberFormatter.number(from: string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDouble(forKey: "value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
}

final class TaxPercentage: NSObject, NSCoding {
    var value: Double
    private let taxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    var text: String? {
        get {
            return taxFormatter.string(from: value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = taxFormatter.number(from: string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDouble(forKey: "value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
}

final class TipPercentage: NSObject, NSCoding {
    var value: Double
    private let tipFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var text: String? {
        get {
            return tipFormatter.string(from: value)
        }
    }
    
    init(value: Double) {
        self.value = value
        
        super.init()
    }
    
    init(string: String) {
        if let value = tipFormatter.number(from: string) as? Double {
            self.value = value
        } else {
            self.value = 0.0
        }
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeDouble(forKey: "value")
        
        super.init()
    }
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
}

enum CalculationMethod: String {
    case NoRounding = "NoRounding"
    case RoundedTotal = "RoundedTotal"
    case RoundedTip = "RoundedTip"
}

enum TipCalculationError: ErrorProtocol {
    case receiptParseError
    case taxParseError
    case tipParseError
}
