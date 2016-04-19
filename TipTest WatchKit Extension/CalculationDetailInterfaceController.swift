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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        guard let tipData = context as? TipData else {
            return
        }
        
        subtotalLabel.setText(tipData.subtotal.text ?? "")
        taxLabel.setText(tipData.taxAmount.text ?? "")
        receiptLabel.setText(tipData.receiptTotal.text ?? "")
        tipLabel.setText(tipData.tipAmount.text ?? "")
        totalLabel.setText(tipData.finalTotal.text ?? "")

    }
    
}
