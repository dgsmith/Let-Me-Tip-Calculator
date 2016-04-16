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
    
    let defaults = NSUserDefaults()
    let subtotalKey = "subtotal"
    let receiptTotalKey = "receiptTotal"
    let taxPctKey = "taxPct"
    let taxAmtKey = "taxAmt"
    let tipPctKey = "tipPct"
    let tipAmtKey = "tipAmt"
    let tipAndTotalKey = "tipAndTotal"
    let currentRoundingKey = "currentRounding"
    
    var currentRounding = 1 // 0 = total, 1 = none, 2 = tip
    
    let tipCalc = TipCalculatorModel(total: 35.26, taxPct: 0.06)
    
    let totalFormatter = NSNumberFormatter()
    let taxFormatter   = NSNumberFormatter()
    let tipFormatter   = NSNumberFormatter()
    
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
        if let rounding = defaults.objectForKey(currentRoundingKey) as? Int {
            currentRounding = rounding
            setMenuItems()
        } else {
            currentRounding = 1
            setMenuItems()
        }
        
        totalFormatter.numberStyle = .CurrencyStyle
        totalFormatter.maximumFractionDigits = 2
        taxFormatter.numberStyle = .PercentStyle
        taxFormatter.maximumFractionDigits = 3
        tipFormatter.numberStyle = .PercentStyle
        tipFormatter.maximumFractionDigits = 2
        
//        to fix things...
//        defaults.setObject("$35.26", forKey: receiptTotalKey)
//        defaults.setObject("0.08%", forKey: taxPctKey)
//        defaults.setObject("0.15%", forKey: tipPctKey)
        
        // calculate!
        reloadData()
    }
    
    override func didAppear() {
        // This method is called when watch view controller is about to be visible to user
        super.didAppear()
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
        if segueIdentifier == "TipDetail" {
            let tipRow = tipRows[rowIndex]
            return tipRow
        }
        if segueIdentifier == "CalcDetail" {
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
                row.titleLabel.setText(Array(tipRows[i].keys)[0])
                row.detailLabel.setText(Array(tipRows[i].values)[0])
//                print(Array(tipRows[i].keys)[0])
//                print(Array(tipRows[i].values)[0])
            }
            if let row = tipTable.rowControllerAtIndex(i) as? CalcRow {
                row.titleLabel.setText(Array(tipRows[i].keys)[0])
                row.detailLabel.setText(Array(tipRows[i].values)[0])
//                print(Array(tipRows[i].keys)[0])
//                print(Array(tipRows[i].values)[0])
            }
            if let row = tipTable.rowControllerAtIndex(i) as? TotalRow {
                row.titleLabel.setText(Array(tipRows[i].keys)[0])
                row.detailLabel.setText(Array(tipRows[i].values)[0])
//                print(Array(tipRows[i].keys)[0])
//                print(Array(tipRows[i].values)[0])
            }
        }
    }
    
    func reloadData() {
        defaults.synchronize()
        if let receiptTotalString = defaults.objectForKey(receiptTotalKey) as? String, taxPctString = defaults.objectForKey(taxPctKey) as? String {
            if let receiptTotal = totalFormatter.numberFromString(receiptTotalString) as? Double, taxPct = taxFormatter.numberFromString(taxPctString) as? Double {
                tipCalc.receiptTotal = receiptTotal
                tipCalc.taxPct = taxPct
            }
        } else {
            tipCalc.receiptTotal = 35.26
            tipCalc.taxPct = 0.06
        }
        
        if let tipString = defaults.objectForKey(tipPctKey) as? String, tipPct = tipFormatter.numberFromString(tipString) as? Double {
            tipCalc.tipPct = tipPct
        } else {
            tipCalc.tipPct = 0.15
        }
        
        switch currentRounding {
        case 1: // no rounding
            tipCalc.calcTipWith(TipPct: tipCalc.tipPct)
        case 2: // rounded tip
            tipCalc.calcRoundedTipFrom(TipPct: tipCalc.tipPct)
        case 0: // rounded total
            tipCalc.calcRoundedTotalFrom(TipPct: tipCalc.tipPct)
        default:
            print("incorrect rounding info!", terminator: "\n")
            tipCalc.calcTipWith(TipPct: tipCalc.tipPct)
        }
        
        tipRows[0]["Receipt Total"]     = totalFormatter.stringFromNumber(tipCalc.receiptTotal)!
        tipRows[1]["Tax Percentage"]    = taxFormatter.stringFromNumber(tipCalc.taxPct)!
        tipRows[2]["Tip Percentage"]    = tipFormatter.stringFromNumber(tipCalc.tipPct)!
        tipRows[3]["Tip Amount"]        = totalFormatter.stringFromNumber(tipCalc.tipAmt)!
        tipRows[4]["Total+Tip"]         = totalFormatter.stringFromNumber(tipCalc.total)!
    
        defaults.setObject(tipRows[2]["Tip Percentage"], forKey: tipPctKey)
        defaults.setObject(tipRows[3]["Tip Amount"], forKey: tipAmtKey)
        defaults.setObject(tipRows[4]["Total+Tip"], forKey: tipAndTotalKey)
        defaults.setObject(totalFormatter.stringFromNumber(tipCalc.subtotal)!, forKey: subtotalKey)
        defaults.setObject(String(format: "$%0.2f", tipCalc.taxAmt), forKey: taxAmtKey)

        defaults.synchronize()
        self.reloadTable()
    }
    
    func setMenuItems() {
        switch currentRounding {
        case 1: // None
            addMenuItemWithItemIcon(.Accept, title: "Normal", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: #selector(InterfaceController.roundTotalAction))
        case 2: // Tip
            addMenuItemWithItemIcon(.Decline, title: "Normal", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Accept, title: "Tip Round", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: #selector(InterfaceController.roundTotalAction))
        case 0: // Total
            addMenuItemWithItemIcon(.Decline, title: "Normal", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Accept, title: "Total Round", action: #selector(InterfaceController.roundTotalAction))
        default:
            addMenuItemWithItemIcon(.Accept, title: "Normal", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Decline, title: "Tip Round", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Decline, title: "Total Round", action: #selector(InterfaceController.roundTotalAction))
            NSLog("error in menu items")
        }
        
    }

}
