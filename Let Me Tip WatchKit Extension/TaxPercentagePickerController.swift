//
//  TaxPercentagePickerController.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/19/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

class TaxPercentagePickerController: WKInterfaceController {
    
    var tipData: TipData!
    
    @IBOutlet var wholeTaxPercentagePicker: WKInterfacePicker!
    @IBOutlet var fractionalTaxPercentagePicker: WKInterfacePicker!
    
    var currentWholeTaxPercentageIndex: Int!
    var currentFractionalTaxPercentageIndex: Int!
    
    override func awake(withContext context: AnyObject?) {
        if let context = context as? TipData {
            tipData = context
        }
        
        let wholeTaxPercentagePickerItems: [WKPickerItem] = (0...9).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%i", i)
            return pickerItem
        }
        wholeTaxPercentagePicker.setItems(wholeTaxPercentagePickerItems)
        
        let fractionalTaxPercentagePickerItems: [WKPickerItem] = (0...999).map { i in
            let pickerItem = WKPickerItem()
            pickerItem.title = String(format: "%03i", i)
            return pickerItem
        }
        fractionalTaxPercentagePicker.setItems(fractionalTaxPercentagePickerItems)
        
        let adjustedPercentage = tipData.taxPercentage.value * 100.0
        
        let wholeIndex = floor(adjustedPercentage)
        let fractionalIndex = (adjustedPercentage * 1000.0) - (wholeIndex * 1000.0)
        
        currentWholeTaxPercentageIndex = Int(wholeIndex)
        currentFractionalTaxPercentageIndex = Int(round(fractionalIndex))
        
        wholeTaxPercentagePicker.setSelectedItemIndex(currentWholeTaxPercentageIndex)
        fractionalTaxPercentagePicker.setSelectedItemIndex(currentFractionalTaxPercentageIndex)
        
        super.awake(withContext: context)
    }
    
    override func willDisappear() {
        
        let newValue = (Double(currentWholeTaxPercentageIndex) + ((Double(currentFractionalTaxPercentageIndex) / 1000.0))) / 100.0
        tipData.taxPercentage = TaxPercentage(value: newValue)
        tipData.calculate()
        
        tipData.saveData()
        super.willDisappear()
    }
    
    // MARK: - IBActions
    @IBAction func wholeDollarAmountValueChanged(_ value: Int) {
        currentWholeTaxPercentageIndex = value
    }
    
    @IBAction func fractionalDollarAmountValueChanged(_ value: Int) {
        currentFractionalTaxPercentageIndex = value
    }
    
}
