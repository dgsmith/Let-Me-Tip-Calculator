//
//  TaxInterfaceController.swift
//  Watch Extension
//
//  Created by Grayson Smith on 7/7/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import WatchKit

final class TaxInterfaceController: WatchTipView {
    
    var taxInputMethod: TaxInputMethod = .taxPercentage
    
    @IBOutlet weak var dollarSignLabel: WKInterfaceLabel!
    @IBOutlet weak var percentSignLabel: WKInterfaceLabel!
    
    override init() {
        super.init()
        
        setPickerItems()
    }
    
    override func pickerDidSettle(_ picker: WKInterfacePicker) {
        if !updated {
            
            var (string, value): (String, NSNumber)
            switch taxInputMethod {
            case .taxPercentage:
                let taxPercentage = (Double(currentWholeNumberIndex) + (Double(currentFractionalNumberIndex) / 1000.0)) / 100.0
                (string, value) = ("taxPercentage", NSNumber(value: taxPercentage))
            case .taxAmount:
                let taxAmount = Double(currentWholeNumberIndex) + (Double(currentFractionalNumberIndex) / 100.0)
                (string, value) = ("taxAmount", NSNumber(value: taxAmount))
            }
            
            let data = [string: value]
            tipPresenter.update(withInputs: data) { (data) in
                self.updateDisplay(data: data)
            }
        } else {
            updated = false
        }
    }
    
    override func setInitialDisplay(data: [String: AnyObject]) {
        if let taxPercentage            = data["taxPercentage"] as? NSNumber,
            let taxAmount               = data["taxAmount"] as? NSNumber,
            let tipAmount               = data["tipAmount"] as? NSNumber,
            let tipPercentage           = data["tipPercentage"] as? NSNumber,
            let finalTotal              = data["finalTotal"] as? NSNumber,
            let calculationMethodRaw    = data["calculationMethod"] as? NSNumber,
            let calculationMethod       = TipCalculationMethod(rawValue: calculationMethodRaw.intValue),
            let taxInputMethodRaw       = data["taxInputMethod"] as? NSNumber,
            let taxInputMethod          = TaxInputMethod(rawValue: taxInputMethodRaw.intValue) {
            
            self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: tipAmount) ?? "$0.00")
            let tipPercentageTotalText = self.shortTipFormatter.string(from: tipPercentage) ?? "0.0%"
            self.tipPercentageTotalLabel.setText("(\(tipPercentageTotalText))")
            self.finalTotalLabel.setText(self.decimalFormatter.string(from: finalTotal) ?? "$0.00")
            
            self.taxInputMethod = taxInputMethod
            
            setMenuItems(withCalculationMethod: calculationMethod)
            
            var newWholeNumberIndex: Int
            var newFractionalNumberIndex: Int
            switch taxInputMethod {
            case .taxPercentage:
                let adjustedTaxPercentage = taxPercentage.doubleValue * 100.0
                let wholeIndex = floor(adjustedTaxPercentage)
                let fractionalIndex = (adjustedTaxPercentage * 100.0) - (wholeIndex * 100.0)
                
                newWholeNumberIndex = Int(wholeIndex)
                newFractionalNumberIndex = Int(round(fractionalIndex))
            case .taxAmount:
                let wholeIndex = floor(taxAmount.doubleValue)
                let fractionalIndex = (taxAmount.doubleValue * 100.0) - (wholeIndex * 100.0)
                
                newWholeNumberIndex = Int(wholeIndex)
                newFractionalNumberIndex = Int(round(fractionalIndex))
            }
            
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
    
    override func setMenuItems(withCalculationMethod method: TipCalculationMethod) {
        super.setMenuItems(withCalculationMethod: method)
        
        switch taxInputMethod {
        case .taxPercentage:
            addMenuItem(with: .info, title: "Tax Amount", action: #selector(TaxInterfaceController.switchTaxInputMethod))
        case .taxAmount:
            addMenuItem(with: .info, title: "Tax Percentage", action: #selector(TaxInterfaceController.switchTaxInputMethod))
        }
    }
    
    func switchTaxInputMethod() {
        if taxInputMethod == .taxPercentage {
            taxInputMethod = .taxAmount
        } else if taxInputMethod == .taxAmount {
            taxInputMethod = .taxPercentage
        }
        
        setPickerItems()
        setDataLabels()
        
        let data = ["taxInputMethod": NSNumber(value: taxInputMethod.rawValue)]
        tipPresenter.update(withInputs: data) { (data) in
            self.setInitialDisplay(data: data)
        }
    }
    
    func setPickerItems() {
        switch taxInputMethod {
        case .taxPercentage:
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
        case .taxAmount:
            let wholeNumberPickerItems: [WKPickerItem] = (0...99).map { (index) in
                let pickerItem = WKPickerItem()
                pickerItem.title = String(format: "%02i", index)
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
    }
    
    func setDataLabels() {
        dollarSignLabel.setHidden(taxInputMethod != .taxAmount)
        percentSignLabel.setHidden(taxInputMethod != .taxPercentage)
        let title = taxInputMethod == .taxAmount ? "Tax Amount" : "Tax Percent"
        setTitle(title)
    }
}
