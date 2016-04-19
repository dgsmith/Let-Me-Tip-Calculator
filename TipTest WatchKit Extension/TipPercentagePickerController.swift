//
//  TipPercentagePickerController.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/19/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

class TipPercentagePickerController: WKInterfaceController {
    
    var tipData: TipData!
    
    @IBOutlet var wholeTipPercentagePicker: WKInterfacePicker!
    @IBOutlet var fractionalTipPercentagePicker: WKInterfacePicker!
    
    var currentWholeTipPercentageIndex: Int!
    var currentFractionalTipPercentageIndex: Int!
    
    override func awakeWithContext(context: AnyObject?) {
        if let context = context as? TipData {
            tipData = context
        }
        
        let wholeTipPercentagePickerItems: [WKPickerItem] = (0...99).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%02i", i)
            return pickerItem
        }
        wholeTipPercentagePicker.setItems(wholeTipPercentagePickerItems)
        
        let fractionalTipPercentagePickerItems: [WKPickerItem] = (0...99).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%02i", i)
            return pickerItem
        }
        fractionalTipPercentagePicker.setItems(fractionalTipPercentagePickerItems)
        
        let adjustedPercentage = tipData.tipPercentage.value * 100.0
        
        let wholeIndex = floor(adjustedPercentage)
        let fractionalIndex = (adjustedPercentage * 100.0) - (wholeIndex * 100.0)
        
        currentWholeTipPercentageIndex = Int(wholeIndex)
        currentFractionalTipPercentageIndex = Int(round(fractionalIndex))
        
        wholeTipPercentagePicker.setSelectedItemIndex(currentWholeTipPercentageIndex)
        fractionalTipPercentagePicker.setSelectedItemIndex(currentFractionalTipPercentageIndex)
        
        super.awakeWithContext(context)
    }
    
    override func willDisappear() {
        
        let newValue = (Double(currentWholeTipPercentageIndex) + ((Double(currentFractionalTipPercentageIndex) / 100.0))) / 100.0
        tipData.tipPercentage = TipPercentage(value: newValue)
        tipData.calculate()
        
        tipData.saveData()
        super.willDisappear()
    }
    
    // MARK: - IBActions
    @IBAction func wholeDollarAmountValueChanged(value: Int) {
        currentWholeTipPercentageIndex = value
    }
    
    @IBAction func fractionalDollarAmountValueChanged(value: Int) {
        currentFractionalTipPercentageIndex = value
    }
    
}
