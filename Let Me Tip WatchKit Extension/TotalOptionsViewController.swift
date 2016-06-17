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
    
    var tipData: TipData!
    
    var splits: Int = 1 {
        didSet {
            updateDisplay()
        }
    }
    
    var splitTotal: DollarAmount!
    var splitTip: DollarAmount!
    
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        if let context = context as? TipData {
            tipData = context
        }
        
        splitTotal = DollarAmount(value: 0.0)
        splitTip = DollarAmount(value: 0.0)
        splitSlider.setValue(Float(splits))
        
        updateDisplay()
    }
    
    @IBAction func sliderValueChanged(_ value: Float) {
        guard value >= 1 else {
            splitSlider.setValue(1)
            splits = 1
            return
        }
        splits = Int(value)
    }
    
    func updateDisplay() {
        splitTotal.value = tipData.finalTotal.value / Double(splits)
        splitTip.value = tipData.tipAmount.value / Double(splits)
        
        tipLabel.setText(tipData.tipAmount.text ?? "")
        newTipLabel.setText(splitTip.text ?? "")
        
        totalLabel.setText(tipData.finalTotal.text ?? "")
        newTotalLabel.setText(splitTotal.text ?? "")
    }
}
