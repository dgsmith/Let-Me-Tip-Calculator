//
//  ReceiptInterfaceController.swift
//  Watch Extension
//
//  Created by Grayson Smith on 7/7/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

final class ReceiptInterfaceController: WatchTipView {
    
    override init() {
        super.init()
        
        let wholeNumberPickerItems: [WKPickerItem] = (0...999).map { (index) in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%03i", index)
            return pickerItem
        }
        wholeNumberPicker.setItems(wholeNumberPickerItems)
        
        let fractionalNumberPickerItems: [WKPickerItem] = (0...99).map { (index) in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%02i", index)
            return pickerItem
        }
        fractionalNumberPicker.setItems(fractionalNumberPickerItems)
    }
    
    override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if !updated {
            let receiptTotal = Double(currentWholeNumberIndex) + (Double(currentFractionalNumberIndex) / 100.0)
            let data = ["receiptTotal": receiptTotal]
            
            tipPresenter?.update(withInputs: data) { (data) in
                updateDisplay(data: data)
            }
        } else {
            updated = false
        }
    }
    
    override func setInitialDisplay(data: [String: AnyObject]) {
        if let receiptTotal             = data["receiptTotal"] as? Double,
            let tipAmount               = data["tipAmount"] as? Double,
            let finalTotal              = data["finalTotal"] as? Double,
            let calculationMethodRaw    = data["calculationMethod"] as? Int,
            let calculationMethod       = TipCalculationMethod(rawValue: calculationMethodRaw) {
            
            self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: tipAmount) ?? "$0.00")
            self.finalTotalLabel.setText(self.decimalFormatter.string(from: finalTotal) ?? "$0.00")
            
            setMenuItems(withCalculationMethod: calculationMethod)
            
            let wholeIndex = floor(receiptTotal)
            let fractionalIndex = (receiptTotal * 100.0) - (wholeIndex * 100.0)
            
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
