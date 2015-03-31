//
//  CalculationDetailInterfaceController.swift
//  TipTest
//
//  Created by Grayson Smith on 3/18/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit

class CalculationDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var subtotalLabel:WKInterfaceLabel!
    @IBOutlet weak var taxLabel:WKInterfaceLabel!
    @IBOutlet weak var receiptLabel:WKInterfaceLabel!
    @IBOutlet weak var tipLabel:WKInterfaceLabel!
    @IBOutlet weak var totalLabel:WKInterfaceLabel!
    
    let defaults = NSUserDefaults(suiteName: "group.TipTestGroup")!
    let subtotalKey = "subtotal"
    let receiptTotalKey = "recieptTotal"
    let taxAmtKey = "taxAmt"
    let tipAmtKey = "tipAmt"
    let tipAndTotalKey = "tipAndTotal"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        defaults.synchronize()
        
        if let subtotal = defaults.objectForKey(subtotalKey) as String? {
            subtotalLabel.setText(subtotal)
        }
        if let tax = defaults.objectForKey(taxAmtKey) as String? {
            taxLabel.setText(tax)
        }
        if let receipt = defaults.objectForKey(receiptTotalKey) as String? {
            receiptLabel.setText(receipt)
        }
        if let tip = defaults.objectForKey(tipAmtKey) as String? {
            tipLabel.setText(tip)
        }
        if let total = defaults.objectForKey(tipAndTotalKey) as String? {
            totalLabel.setText(total)
        }
    }
    
}
