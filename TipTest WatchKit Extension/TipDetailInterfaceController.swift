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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let recieptTotalKey = "recieptTotal"
    let taxPctKey = "taxPct"
    let tipPctKey = "tipPct"
    
    var editTotal = false
    var editTax = false
    var editTip = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        savedLabel.setHidden(true)
        editTotal = false
        editTax = false
        editTip = false
        
        if let row = context as? Dictionary<String,String> {
            self.row = row
            if let keyString = self.row.keys.first as String? {
                setTitle(keyString)
                
                if let valueString = self.row.values.first as String? {
                    var newStr: String
                    switch keyString {
                    case "Reciept Total":
                        self.editTotal = true;
                        newStr = valueString.stringByReplacingOccurrencesOfString("$", withString: "")
                    case "Tax Percentage":
                        self.editTax = true
                        newStr = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                        var currentString = newStr.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        var currentValue = (currentString as NSString).intValue
                        var newValue: Double = Double(currentValue) / 100.0
                        newStr = NSString(format: "%.2f", newValue)
                    case "Tip Percentage":
                        self.editTip = true
                        newStr = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                        var currentString = newStr.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        var currentValue = (currentString as NSString).intValue
                        var newValue: Double = Double(currentValue) / 100.0
                        newStr = NSString(format: "%.2f", newValue)
                    default:
                        newStr = "0.00"
                        NSLog("There's an error here")
                    }
                    updateLabel(newStr)
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
                defaults.removeObjectForKey(recieptTotalKey)
                let newStr = "$" + str
                defaults.setObject(newStr, forKey: recieptTotalKey)
            } else if editTax {
                defaults.removeObjectForKey(taxPctKey)
                let temp = (str as NSString).doubleValue * 100.0
                let newStr = String(format: "%d%%", Int(temp))
                defaults.setObject(newStr, forKey: taxPctKey)
            } else if editTip {
                defaults.removeObjectForKey(tipPctKey)
                let temp = (str as NSString).doubleValue * 100.0
                let newStr = String(format: "%d%%", Int(temp))
                defaults.setObject(newStr, forKey: tipPctKey)
            } else {
                NSLog("Error in edit mode")
            }
            defaults.synchronize()
        }
    }
    
    @IBAction func clearButtonHit() {
        updateLabel("0.00")
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
        var newString = NSString(format: "%.2f", Double(newValue)/100.0)
        
        updateLabel(newString)
    }
    
    func removeFromString() {
        var currentString = outputString.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var currentValue = (currentString as NSString).intValue
        var newValue = (currentValue / 10)
        var newString = NSString(format: "%.2f", Double(newValue)/100.0)
        
        updateLabel(newString)
        
    }
    
}
