//
//  InterfaceController.swift
//  TipTest WatchKit Extension
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit
import Foundation

enum Rounding : Int {
    case RoundedTotal = 0, None, RoundedTip
}

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tipTable: WKInterfaceTable!
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    let subtotalKey = "subtotal"
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let taxAmtKey = "taxAmt"
    let tipPctKey = "tipPct"
    let tipAmtKey = "tipAmt"
    let tipAndTotalKey = "tipAndTotal"
    let currentRoundingKey = "currentRounding"
    
    var currentRounding = 1 // 0 = total, 1 = none, 2 = tip
    
    var tipRows: [Dictionary<String,String>] = [
        ["Receipt Total":"$35.26"],
        ["Tax Percentage":"6%"],
        ["Tip Percentage":"15%"],
        ["Tip Amount":""],
        ["Total+Tip":""]
    ]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        setTitle("Let Me Tip")
        if let rounding = defaults.objectForKey(currentRoundingKey) as Int? {
            currentRounding = rounding
            setMenuItems()
        } else {
            currentRounding = 1
            setMenuItems()
        }
        // calculate!
        reloadData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        reloadData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        clearAllMenuItems()
    }
    
    func noRoundingAction() {
        if currentRounding == 1 {
            // do nothing...
        } else {
            currentRounding = 1
            defaults.removeObjectForKey(currentRoundingKey)
            defaults.setObject(currentRounding, forKey: currentRoundingKey)
            defaults.synchronize()
            clearAllMenuItems()
            setMenuItems()
            reloadData()
        }
    }
    
    func roundTipAction() {
        if currentRounding == 2 {
            // do nothing...
        } else {
            currentRounding = 2
            defaults.removeObjectForKey(currentRoundingKey)
            defaults.setObject(currentRounding, forKey: currentRoundingKey)
            defaults.synchronize()
            clearAllMenuItems()
            setMenuItems()
            reloadData()
        }
    }
    
    func roundTotalAction() {
        if currentRounding == 0 {
            // do nothing...
        } else {
            currentRounding = 0
            defaults.removeObjectForKey(currentRoundingKey)
            defaults.setObject(currentRounding, forKey: currentRoundingKey)
            defaults.synchronize()
            clearAllMenuItems()
            setMenuItems()
            reloadData()
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "TipDetails" {
            let tipRow = tipRows[rowIndex]
            return tipRow
        }
        if segueIdentifier == "CalcDetails" {
            let tipRow = tipRows[rowIndex]
            return tipRow
        }
        if segueIdentifier == "TotalOptions" {
            let tipRow = tipRows[rowIndex]
            return tipRow
        }
        
        return nil
    }
    
    func reloadTable() {
        tipTable.setRowTypes(["TipRow", "TipRow", "TipRow", "CalcRow", "TotalRow"])
        
        for i in 0..<tipRows.count {
            if let row = tipTable.rowControllerAtIndex(i) as? TipRow {
                row.titleLabel.setText(tipRows[i].keys.array[0])
                row.detailLabel.setText(tipRows[i].values.array[0])
            }
            if let row = tipTable.rowControllerAtIndex(i) as? CalcRow {
                row.titleLabel.setText(tipRows[i].keys.array[0])
                row.detailLabel.setText(tipRows[i].values.array[0])
            }
            if let row = tipTable.rowControllerAtIndex(i) as? TotalRow {
                row.titleLabel.setText(tipRows[i].keys.array[0])
                row.detailLabel.setText(tipRows[i].values.array[0])
            }
        }
    }
    
    func reloadData() {
        defaults.synchronize()
        
        if let receiptString = defaults.objectForKey(receiptTotalKey) as String? {
            tipRows[0]["Receipt Total"] = receiptString
        }
        if let taxString = defaults.objectForKey(taxPctKey) as String? {
            tipRows[1]["Tax Percentage"] = taxString
        }
        if let tipString = defaults.objectForKey(tipPctKey) as String? {
            tipRows[2]["Tip Percentage"] = tipString
        }
        if let tipAmtString = defaults.objectForKey(tipAmtKey) as String? {
            tipRows[3]["Tip Amount"] = tipAmtString
        }
        if let tipAndTotalString = defaults.objectForKey(tipAndTotalKey) as String? {
            tipRows[4]["Total+Tip"] = tipAndTotalString
        }

        WKInterfaceController.openParentApplication(["tipInfo":tipRows, "roundingInfo":currentRounding], reply: { (replyInfo, error) -> Void in
            if let tipData = replyInfo["tipData"] as? NSData {
                if let tipInfo = NSKeyedUnarchiver.unarchiveObjectWithData(tipData) as? [Dictionary<String,String>] {
                    //self.tipRows[0]["Reciept Total"]  = tipInfo[0]["Reciept Total"]
                    //self.tipRows[1]["Tax Percentage"] = tipInfo[1]["Tax Percentage"]
                    self.tipRows[2]["Tip Percentage"] = tipInfo[2]["Tip Percentage"]
                    self.tipRows[3]["Tip Amount"]     = tipInfo[3]["Tip Amount"]
                    self.tipRows[4]["Total+Tip"]      = tipInfo[4]["Total+Tip"]
                    
                    //self.defaults.removeObjectForKey(self.recieptTotalKey)
                    //self.defaults.removeObjectForKey(self.taxPctKey)
                    self.defaults.removeObjectForKey(self.tipPctKey)
                    self.defaults.removeObjectForKey(self.tipAmtKey)
                    self.defaults.removeObjectForKey(self.tipAndTotalKey)
                    self.defaults.removeObjectForKey(self.subtotalKey)
                    self.defaults.removeObjectForKey(self.taxAmtKey)
                    
                    //self.defaults.setObject(tipInfo[0]["Reciept Total"], forKey: self.recieptTotalKey)
                    //self.defaults.setObject(tipInfo[1]["Tax Percentage"], forKey: self.taxPctKey)
                    self.defaults.setObject(tipInfo[2]["Tip Percentage"], forKey: self.tipPctKey)
                    self.defaults.setObject(tipInfo[3]["Tip Amount"], forKey: self.tipAmtKey)
                    self.defaults.setObject(tipInfo[4]["Total+Tip"], forKey: self.tipAndTotalKey)
                    self.defaults.setObject(tipInfo[5]["subtotal"], forKey: self.subtotalKey)
                    self.defaults.setObject(tipInfo[6]["taxAmt"], forKey: self.taxAmtKey)
                    
                    self.defaults.synchronize()
                    self.reloadTable()
                }
            }
        })
    }
    
    func setMenuItems() {
        switch currentRounding {
        case 1: // None
            addMenuItemWithItemIcon(.Accept, title: "Normal", action: Selector("noRoundingAction"))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: Selector("roundTipAction"))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: Selector("roundTotalAction"))
        case 2: // Tip
            addMenuItemWithItemIcon(.Decline, title: "Normal", action: Selector("noRoundingAction"))
            addMenuItemWithItemIcon(.Accept, title: "Tip Round", action: Selector("roundTipAction"))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: Selector("roundTotalAction"))
        case 0: // Total
            addMenuItemWithItemIcon(.Decline, title: "Normal", action: Selector("noRoundingAction"))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: Selector("roundTipAction"))
            addMenuItemWithItemIcon(.Accept, title: "Total Round", action: Selector("roundTotalAction"))
        default:
            addMenuItemWithItemIcon(.Accept, title: "Normal", action: Selector("noRoundingAction"))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: Selector("roundTipAction"))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: Selector("roundTotalAction"))
            NSLog("error in menu items")
        }
        
    }

}
