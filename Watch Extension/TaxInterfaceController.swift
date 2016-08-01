//
//  TaxInterfaceController.swift
//  Watch Extension
//
//  Created by Grayson Smith on 7/7/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

final class TaxInterfaceController: WatchTipView {
    
    override init() {
        super.init()
        
        let wholeNumberPickerItems: [WKPickerItem] = (0...9).map { (index) in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%i", index)
            return pickerItem
        }
        wholeNumberPicker.setItems(wholeNumberPickerItems)
        
        let fractionalNumberPickerItems: [WKPickerItem] = (0...999).map { (index) in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%03i", index)
            return pickerItem
        }
        fractionalNumberPicker.setItems(fractionalNumberPickerItems)
    }
    
    override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if !updated {
            let taxPercentage = (Double(currentWholeNumberIndex) + (Double(currentFractionalNumberIndex) / 1000.0)) / 100.0
            let data = ["taxPercentage": taxPercentage]
            
            tipPresenter?.update(withInputs: data) { (data) in
                updateDisplay(data: data)
            }
        } else {
            updated = false
        }
    }
    
    override func setInitialDisplay(data: [String: AnyObject]) {
        if let taxPercentage            = data["taxPercentage"] as? Double,
            let tipAmount               = data["tipAmount"] as? Double,
            let finalTotal              = data["finalTotal"] as? Double,
            let calculationMethodRaw    = data["calculationMethod"] as? Int,
            let calculationMethod       = TipCalculationMethod(rawValue: calculationMethodRaw) {
            
            self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: tipAmount) ?? "$0.00")
            self.finalTotalLabel.setText(self.decimalFormatter.string(from: finalTotal) ?? "$0.00")
            
            setMenuItems(withCalculationMethod: calculationMethod)
            
            let adjustedTaxPercentage = taxPercentage * 100.0
            let wholeIndex = floor(adjustedTaxPercentage)
            let fractionalIndex = (adjustedTaxPercentage * 100.0) - (wholeIndex * 100.0)
            
            let newWholeNumberIndex = Int(wholeIndex)
            let newFractionalNumberIndex = Int(round(fractionalIndex))
            
            if currentWholeNumberIndex != newWholeNumberIndex ||
                currentFractionalNumberIndex != newFractionalNumberIndex {
                
                currentWholeNumberIndex = newWholeNumberIndex
                currentFractionalNumberIndex = newFractionalNumberIndex
                
                wholeNumberPicker.setSelectedItemIndex(currentWholeNumberIndex)
                fractionalNumberPicker.setSelectedItemIndex(currentFractionalNumberIndex)
                updated = true
            }
        }
    }
}
