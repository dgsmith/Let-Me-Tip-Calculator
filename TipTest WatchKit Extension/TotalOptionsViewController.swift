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
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let tipPctKey = "tipPct"
    let tipAmtKey = "tipAmt"
    let tipAndTotalKey = "tipAndTotal"
    let splitAmtKey = "splitAmt"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        defaults.synchronize()
        
        if let sliderPos = defaults.objectForKey(splitAmtKey) as Int? {
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
        updateDisplay()
    }
    
    func updateDisplay() {
        if var split = defaults.objectForKey(splitAmtKey) as Int? {
            if split < 1 {
                split = 1
            }
            if let tipAmt = defaults.objectForKey(tipAmtKey) as String? {
                tipLabel.setText(tipAmt)
                // calculations
                WKInterfaceController.openParentApplication(["divide":tipAmt, "by":split], reply: { (replyInfo, error) -> Void in
                    if let divideData = replyInfo["divided"] as NSData? {
                        if let newTipAmt = NSKeyedUnarchiver.unarchiveObjectWithData(divideData) as String? {
                            //NSLog("got \(newTipAmt)")
                            self.newTipLabel.setText(newTipAmt)
                        }
                    } else {
                        NSLog("didn't get data")
                    }
                })
            }
            if let totalAmt = defaults.objectForKey(tipAndTotalKey) as String? {
                totalLabel.setText(totalAmt)
                WKInterfaceController.openParentApplication(["divide":totalAmt, "by":split], reply: { (replyInfo, error) -> Void in
                    if let divideData = replyInfo["divided"] as NSData? {
                        if let newTotal = NSKeyedUnarchiver.unarchiveObjectWithData(divideData) as String? {
                            //NSLog("got \(newTotal)")
                            self.newTotalLabel.setText(newTotal)
                        }
                    } else {
                        NSLog("didn't get data")
                    }
                })
            }            
        } else { // first time in here!
            defaults.setObject(1, forKey: splitAmtKey)
            updateDisplay()
        }
    }
}
