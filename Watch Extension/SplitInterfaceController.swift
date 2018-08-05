//
//  SplitInterfaceController.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 9/17/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

class SplitInterfaceController: WatchTipView {
    
    @IBOutlet weak var splitPicker: WKInterfacePicker!
    var currentSplitPickerIndex = 1
    
    override init() {
        super.init()
        
        let splitPickerItems: [WKPickerItem] = (1...10).map { (index) in
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(index)"
            let person = index == 1 ? "person" : "people"
            pickerItem.caption = "\(index) \(person)"
            return pickerItem
        }
        splitPicker.setItems(splitPickerItems)
    }
    
    override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if !updated {
            tipPresenter.update(withInputs: nil) { (data) in
                self.updateDisplay(withData: data)
            }
        } else {
            updated = false
        }
    }
    
    @IBAction func splitPickerValueChanged(_ value: Int) {
        currentSplitPickerIndex = value + 1
    }
    
    override func updateDisplay(withData data: [String: AnyObject]) {
        if let tipAmount    = data["tipAmount"] as? NSNumber,
            let tipPercentage   = data["tipPercentage"] as? NSNumber,
            let finalTotal  = data["finalTotal"] as? NSNumber {
            
            DispatchQueue.main.async {
                let split = Double(self.currentSplitPickerIndex)
                let adjustedTipAmount = NSNumber(value: tipAmount.doubleValue / split)
                let adjustedFinalTotal = NSNumber(value: finalTotal.doubleValue / split)
                
                self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: adjustedTipAmount) ?? "$0.00")
                let tipPercentageTotalText = self.shortTipFormatter.string(from: tipPercentage) ?? "0.0%"
                self.tipPercentageTotalLabel.setText("(\(tipPercentageTotalText))")
                self.finalTotalLabel.setText(self.decimalFormatter.string(from: adjustedFinalTotal) ?? "$0.00")
            }
        }
    }
    
    override func setInitialDisplay(withData data: [String: AnyObject]) {
        if let tipAmount               = data["tipAmount"] as? NSNumber,
            let tipPercentage           = data["tipPercentage"] as? NSNumber,
            let finalTotal              = data["finalTotal"] as? NSNumber,
            let calculationMethodRaw    = data["calculationMethod"] as? NSNumber,
            let calculationMethod       = TipCalculationMethod(rawValue: calculationMethodRaw.intValue) {
            
            self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: tipAmount) ?? "$0.00")
            let tipPercentageTotalText = self.shortTipFormatter.string(from: tipPercentage) ?? "0.0%"
            self.tipPercentageTotalLabel.setText("(\(tipPercentageTotalText))")
            self.finalTotalLabel.setText(self.decimalFormatter.string(from: finalTotal) ?? "$0.00")
            
            setMenuItems(withCalculationMethod: calculationMethod)
            
            currentSplitPickerIndex = 1
            splitPicker.setSelectedItemIndex(currentSplitPickerIndex - 1)
        }
    }
    
}
