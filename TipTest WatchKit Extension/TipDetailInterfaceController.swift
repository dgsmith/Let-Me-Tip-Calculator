//
//  TipDetailInterfaceController.swift
//  TipTest
//
//  Created by Grayson Smith on 3/17/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit
import TipCalcKit

class TipDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var outputLabel: WKInterfaceLabel!
    @IBOutlet weak var savedLabel: WKInterfaceLabel!
    
    var row: Dictionary<String,String>!
    var outputString: String!
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let tipPctKey = "tipPct"
    
    var editTotal = false
    var editTax = false
    var editTip = false
    
    var taxFormatter = NSNumberFormatter()
    var tipFormatter = NSNumberFormatter()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        savedLabel.setHidden(true)
        editTotal = false
        editTax = false
        editTip = false
        
        taxFormatter.numberStyle = .PercentStyle
        taxFormatter.maximumFractionDigits = 3
        tipFormatter.numberStyle = .PercentStyle
        tipFormatter.maximumFractionDigits = 2
        
        if let row = context as? Dictionary<String,String> {
            self.row = row
            if let keyString = self.row.keys.first as String? {
                setTitle(keyString)
                
                if let valueString = self.row.values.first as String? {
                    var newStr: String
                    switch keyString {
                    case "Receipt Total":
                        self.editTotal = true;
                        newStr = valueString.stringByReplacingOccurrencesOfString("$", withString: "")
                        updateLabel(newStr)
                    case "Tax Percentage":
                        self.editTax = true
                        if let dbl = taxFormatter.numberFromString(valueString) as? Double {
                            //newStr = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                            newStr = String(format: "%0.3f", dbl * 100)
                            updateLabel(newStr)
                        }
                    case "Tip Percentage":
                        self.editTip = true
                        if let dbl = tipFormatter.numberFromString(valueString) as? Double {
                            //newStr = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                            newStr = String(format: "%0.2f", dbl * 100)
                            updateLabel(newStr)
                        }
                    default:
                        newStr = "0.00"
                        updateLabel(newStr)
                        NSLog("There's an error here")
                    }
                    //updateLabel(newStr)
                }
            }
            
        }
    }
    
    @IBAction func nineKeyHit() {
        addToString(9);
    }
    
    @IBAction func eightKeyHit() {
        addToString(8)
    }
    
    @IBAction func sevenKeyHit() {
        addToString(7)
    }
    
    @IBAction func sixKeyHit() {
        addToString(6)
    }
    
    @IBAction func fiveKeyHit() {
        addToString(5)
    }
    
    @IBAction func fourKeyHit() {
        addToString(4)
    }
    
    @IBAction func threeKeyHit() {
        addToString(3)
    }
    
    @IBAction func twoKeyHit() {
        addToString(2)
    }
    
    @IBAction func oneKeyHit() {
        addToString(1)
    }
    
    @IBAction func zeroKeyHit() {
        addToString(0)
    }
    
    @IBAction func backKeyHit() {
        removeFromString()
    }
    
    @IBAction func checkKeyHit() {
        savedLabel.setHidden(false);
        if let str = outputString {
            if editTotal {
                defaults.removeObjectForKey(receiptTotalKey)
                let newStr = "$" + str
                defaults.setObject(newStr, forKey: receiptTotalKey)
            } else if editTax {
                defaults.removeObjectForKey(taxPctKey)
                let temp = (str as NSString).doubleValue
                //let newStr = String(format: "%0.3f%%", temp)
                let newStr = taxFormatter.stringFromNumber(temp / 100)
                defaults.setObject(newStr, forKey: taxPctKey)
            } else if editTip {
                defaults.removeObjectForKey(tipPctKey)
                let temp = (str as NSString).doubleValue
                //let newStr = String(format: "%0.2f%%", temp)
                let newStr = tipFormatter.stringFromNumber(temp / 100)
                defaults.setObject(newStr, forKey: tipPctKey)
            } else {
                NSLog("Error in edit mode")
            }
            defaults.synchronize()
        }
    }
    
    @IBAction func clearButtonHit() {
        if self.editTotal || self.editTip {
            updateLabel("0.00")
        } else if self.editTax {
            updateLabel("0.000")
        }
        
    }
    
    func updateLabel(string: String) {
        if let str = string as String? {
            outputString = string
            outputLabel.setText(str)
        }
    }
    
    func addToString(digit: Int!) {
        var currentString = outputString.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var currentValue = (currentString as NSString).intValue
        var newValue = (currentValue * 10) + digit
        if self.editTotal || self.editTip {
            var newString = String(format: "%.2f", Double(newValue)/100.0)
            updateLabel(newString)
        } else if self.editTax {
            var newString = String(format: "%.3f", Double(newValue)/1000.0)
            updateLabel(newString)
        }
    }
    
    func removeFromString() {
        var currentString = outputString.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var currentValue = (currentString as NSString).intValue
        var newValue = (currentValue / 10)
        if self.editTotal || self.editTip {
            var newString = String(format: "%.2f", Double(newValue)/100.0)
            updateLabel(newString)
        } else if self.editTax {
            var newString = String(format: "%.3f", Double(newValue)/1000.0)
            updateLabel(newString)
        }
    }
    
}
