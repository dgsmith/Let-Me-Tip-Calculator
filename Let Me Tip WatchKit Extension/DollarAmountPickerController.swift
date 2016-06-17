//
//  DollarAmountPickerController.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/19/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

class DollarAmountPickerController: WKInterfaceController {
    
    
    var tipData: TipData!
    @IBOutlet var wholeDollarAmountPicker: WKInterfacePicker!
    @IBOutlet var fractionalDollarAmountPicker: WKInterfacePicker!
    
    var currentWholeDollarAmountIndex: Int!
    var currentFractionalDollarAmountIndex: Int!
    
    override func awake(withContext context: AnyObject?) {
        if let context = context as? TipData {
            tipData = context
        }
        
        let wholeDollarAmountPickerItems: [WKPickerItem] = (0...999).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%03i", i)
            return pickerItem
        }
        wholeDollarAmountPicker.setItems(wholeDollarAmountPickerItems)
        
        let fractionalDollarAmountPickerItems: [WKPickerItem] = (0...99).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%02i", i)
            return pickerItem
        }
        fractionalDollarAmountPicker.setItems(fractionalDollarAmountPickerItems)
        
        let wholeIndex = floor(tipData.receiptTotal.value)
        let fractionalIndex = (tipData.receiptTotal.value * 100.0) - (wholeIndex * 100.0)
        
        currentWholeDollarAmountIndex = Int(wholeIndex)
        currentFractionalDollarAmountIndex = Int(round(fractionalIndex))
        
        wholeDollarAmountPicker.setSelectedItemIndex(currentWholeDollarAmountIndex)
        fractionalDollarAmountPicker.setSelectedItemIndex(currentFractionalDollarAmountIndex)
        
        super.awake(withContext: context)
    }
    
    override func willDisappear() {
        
        let newValue = Double(currentWholeDollarAmountIndex) + ((Double(currentFractionalDollarAmountIndex) / 100.0))
        tipData.receiptTotal = DollarAmount(value: newValue)
        tipData.calculate()
        
        tipData.saveData()
        super.willDisappear()
    }
    
    // MARK: - IBActions
    @IBAction func wholeDollarAmountValueChanged(_ value: Int) {
        currentWholeDollarAmountIndex = value
    }
    
    @IBAction func fractionalDollarAmountValueChanged(_ value: Int) {
        currentFractionalDollarAmountIndex = value
    }
    
}
