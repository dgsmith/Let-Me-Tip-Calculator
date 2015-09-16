//
//  TotalOptionsViewController.swift
//  TipTest
//
//  Created by Grayson Smith on 3/18/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit

class TotalOptionsViewController: WKInterfaceController {
    
    @IBOutlet weak var splitSlider: WKInterfaceSlider!
    
    @IBOutlet weak var tipLabel: WKInterfaceLabel!
    @IBOutlet weak var newTipLabel: WKInterfaceLabel!
    
    @IBOutlet weak var totalLabel: WKInterfaceLabel!
    @IBOutlet weak var newTotalLabel: WKInterfaceLabel!
    
    let defaults = NSUserDefaults()
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let tipPctKey = "tipPct"
    let tipAmtKey = "tipAmt"
    let tipAndTotalKey = "tipAndTotal"
    let splitAmtKey = "splitAmt"
    
    let numberFormatter = NSNumberFormatter()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.maximumFractionDigits = 2
        defaults.synchronize()
        
        if let sliderPos = defaults.objectForKey(splitAmtKey) as? Int {
            splitSlider.setValue(Float(sliderPos))
        }
        
        updateDisplay()
        
    }
    
    @IBAction func sliderValueChanged(value: Float) {
        if value < 1 {
            splitSlider.setValue(1)
            return
        }
        defaults.removeObjectForKey(splitAmtKey)
        defaults.setObject(Int(value), forKey: splitAmtKey)
        defaults.synchronize()
        updateDisplay()
    }
    
    func updateDisplay() {
        if var split = defaults.objectForKey(splitAmtKey) as? Int {
            if split < 1 {
                split = 1
            }
            if let tipAmtString = defaults.objectForKey(tipAmtKey) as? String {
                tipLabel.setText(tipAmtString)
                // calculations
                if let tipAmt = numberFormatter.numberFromString(tipAmtString) as? Double {
                    newTipLabel.setText(numberFormatter.stringFromNumber(tipAmt / Double(split))!)
                }
            }
            if let totalAmtString = defaults.objectForKey(tipAndTotalKey) as? String {
                totalLabel.setText(totalAmtString)
                if let totalAmt = numberFormatter.numberFromString(totalAmtString) as? Double {
                    newTotalLabel.setText(numberFormatter.stringFromNumber(totalAmt / Double(split))!)
                }
            }            
        } else { // first time in here!
            defaults.setObject(1, forKey: splitAmtKey)
            defaults.synchronize()
            updateDisplay()
        }
    }
}
