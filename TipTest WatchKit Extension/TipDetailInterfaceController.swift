//
//  TipDetailInterfaceController.swift
//  TipTest
//
//  Created by Grayson Smith on 3/17/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit

class TipDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet var dollarSignLabel: WKInterfaceLabel!
    @IBOutlet var leftSidePicker: WKInterfacePicker!
    @IBOutlet var rightSidePicker: WKInterfacePicker!
    @IBOutlet var percentSignLabel: WKInterfaceLabel!
    
    var leftSidePickerItems  = [WKPickerItem]()
    var rightSidePickerItems = [WKPickerItem]()
    
    var leftIndex: Int = 0
    var rightIndex: Int = 0
    
    var row: Dictionary<String,String>!
    var outputString: String!
    
    let defaults = NSUserDefaults()
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let tipPctKey = "tipPct"
    
    var editTotal = false
    var editTax = false
    var editTip = false
    
    var taxFormatter = NSNumberFormatter()
    var tipFormatter = NSNumberFormatter()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        editTotal = false
        editTax = false
        editTip = false
        
        taxFormatter.numberStyle = .PercentStyle
        taxFormatter.maximumFractionDigits = 3
        tipFormatter.numberStyle = .PercentStyle
        tipFormatter.maximumFractionDigits = 2
        
        if let row = context as? Dictionary<String,String> {
            self.row = row
            if let keyString = self.row.keys.first as String? {
                setTitle(keyString)
                
                if let valueString = self.row.values.first as String? {
                    switch keyString {
                    case "Receipt Total":
                        self.editTotal = true
                        percentSignLabel.setHidden(true)
                        dollarSignLabel.setHidden(false)
                        let leftSidePickerItems: [WKPickerItem] = (0...999).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%03i", i)
                            pickerItem.caption = String(format: "%03i", i)
                            return pickerItem
                        }
                        leftSidePicker.setItems(leftSidePickerItems)
                        let rightSidePickerItems: [WKPickerItem] = (0...99).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%02i", i)
                            pickerItem.caption = String(format: "%02i", i)
                            return pickerItem
                        }
                        rightSidePicker.setItems(rightSidePickerItems)
                        let tempString = valueString.stringByReplacingOccurrencesOfString("$", withString: "")
                        let tempStringArr = tempString.componentsSeparatedByString(".")
                        leftIndex = Int(tempStringArr[0])!
                        rightIndex = Int(tempStringArr[1])!
                        leftSidePicker.setSelectedItemIndex(leftIndex)
                        rightSidePicker.setSelectedItemIndex(rightIndex)
                    case "Tax Percentage":
                        self.editTax = true
                        percentSignLabel.setHidden(false)
                        dollarSignLabel.setHidden(true)
                        let leftSidePickerItems: [WKPickerItem] = (0...99).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%02i", i)
                            pickerItem.caption = String(format: "%02i", i)
                            return pickerItem
                        }
                        leftSidePicker.setItems(leftSidePickerItems)
                        let rightSidePickerItems: [WKPickerItem] = (0...999).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%03i", i)
                            pickerItem.caption = String(format: "%03i", i)
                            return pickerItem
                        }
                        rightSidePicker.setItems(rightSidePickerItems)
                        let tempString = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                        let tempStringArr = tempString.componentsSeparatedByString(".")
                        leftIndex = Int(tempStringArr[0])!
                        leftSidePicker.setSelectedItemIndex(leftIndex)
                        if tempStringArr.count > 1 {
                            rightIndex = Int(tempStringArr[1])!
                            rightSidePicker.setSelectedItemIndex(rightIndex)
                        } else {
                            rightIndex = 0
                            rightSidePicker.setSelectedItemIndex(rightIndex)
                        }
                    case "Tip Percentage":
                        self.editTip = true
                        percentSignLabel.setHidden(false)
                        dollarSignLabel.setHidden(true)
                        let leftSidePickerItems: [WKPickerItem] = (0...99).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%02i", i)
                            pickerItem.caption = String(format: "%02i", i)
                            return pickerItem
                        }
                        leftSidePicker.setItems(leftSidePickerItems)
                        let rightSidePickerItems: [WKPickerItem] = (0...99).map { i in
                            let pickerItem = WKPickerItem()
                            pickerItem.title = String(format: "%02i", i)
                            pickerItem.caption = String(format: "%02i", i)
                            return pickerItem
                        }
                        rightSidePicker.setItems(rightSidePickerItems)
                        let tempString = valueString.stringByReplacingOccurrencesOfString("%", withString: "")
                        let tempStringArr = tempString.componentsSeparatedByString(".")
                        leftIndex = Int(tempStringArr[0])!
                        leftSidePicker.setSelectedItemIndex(leftIndex)
                        if tempStringArr.count > 1 {
                            rightIndex = Int(tempStringArr[1])!
                            rightSidePicker.setSelectedItemIndex(rightIndex)
                        } else {
                            rightIndex = 0
                            rightSidePicker.setSelectedItemIndex(rightIndex)
                        }
                    default:
                        NSLog("There's an error here")
                    }
                }
            }
            
        }
    }
    
    @IBAction func leftSidePickerItemChanged(value: Int) {
        self.leftIndex = value
    }
    
    @IBAction func rightSidePickerItemChanged(value: Int) {
        self.rightIndex = value
    }
    
    override func willDisappear() {
        if editTotal {
            let value = "$\(leftIndex).\(rightIndex)"
            defaults.setObject(value, forKey: receiptTotalKey)
        } else if editTip {
            let value = "\(leftIndex).\(rightIndex)%"
            defaults.setObject(value, forKey: tipPctKey)
        } else if editTax {
            let value = "\(leftIndex).\(rightIndex)%"
            defaults.setObject(value, forKey: taxPctKey)
        }
        defaults.synchronize()
    }
    
}
