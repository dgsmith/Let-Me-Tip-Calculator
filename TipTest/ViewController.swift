//
//  ViewController.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit
import TipCalcKit

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}

let kDGSettingsTotalTextKey     = "TotalTextKey"
let kDGSettingsTaxSliderKey     = "TaxSliderKey"
let kDGSettingsTaxLabelKey      = "TaxLabelKey"
let kDGSettingsTipPctStepperKey = "TipPctStepperKey"
let kDGSettingsTipPctLabelKey   = "TipPctLabelKey"
let kDGSettingsSelectionKey     = "SelectionKey"
let kDGSettingsCalcTotalKey     = "CalcTotalKey"
let kDGSettingsCalcTaxPctKey    = "CalcTaxPctKey"

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var totalTextField: UITextField!
    @IBOutlet weak var taxPctSlider: UISlider!
    @IBOutlet weak var taxPctLabel: UILabel!
    @IBOutlet weak var tipPctStepper: UIStepper!
    @IBOutlet weak var tipPctLabel: UILabel!
    @IBOutlet weak var tipTableView: UITableView!
    @IBOutlet weak var roundingSelection: UISegmentedControl!
    
    enum Rounding : Int {
        case RoundedTotal = 0, None, RoundedTip
    }
    
    let tipCalc = TipCalculatorModel(total: 32.78, taxPct: 0.06)
    //var possibleTips = Dictionary<Int, (tipAmt:Double, total:Double)>()
    var outputlabels:[(String,String)] = []
    //var tipPct: Int = 15
    
    let defaults = NSUserDefaults(suiteName: "group.TipTestGroup")!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let str = defaults.stringForKey(kDGSettingsTotalTextKey) as String? {
            totalTextField.text = str
        }
        if let val = defaults.floatForKey(kDGSettingsTaxSliderKey) as Float? {
            taxPctSlider.value = val
        }
        if let str = defaults.stringForKey(kDGSettingsTaxLabelKey) as String? {
            taxPctLabel.text = str
        }
        if let dbl = defaults.doubleForKey(kDGSettingsTipPctStepperKey) as Double? {
            tipPctStepper.value = dbl
        }
        if let str = defaults.stringForKey(kDGSettingsTipPctLabelKey) as String? {
            tipPctLabel.text = str
        }
        if let int = defaults.integerForKey(kDGSettingsSelectionKey) as Int? {
            roundingSelection.selectedSegmentIndex = int
        }
        if let dbl = defaults.doubleForKey(kDGSettingsCalcTotalKey) as Double? {
            tipCalc.total = dbl
        }
        if let dbl = defaults.doubleForKey(kDGSettingsCalcTaxPctKey) as Double? {
            tipCalc.taxPct = dbl
        }
        outputlabels.insert(("Subtotal:", " "), atIndex: 0)
        outputlabels.insert(("Tax Amount:", " "), atIndex: 1)
        outputlabels.insert(("Reciept Total:", " "), atIndex: 2)
        outputlabels.insert(("Tip Amount: ", " "), atIndex: 3)
        outputlabels.insert(("Final Total:", " "), atIndex: 4)
        
        refreshUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateTapped(sender : AnyObject) {
        totalTextField.resignFirstResponder()
        
        tipCalc.total = Double((totalTextField.text as NSString).doubleValue)
        defaults.setDouble(tipCalc.total, forKey: kDGSettingsCalcTotalKey)
        defaults.setInteger(roundingSelection.selectedSegmentIndex, forKey: kDGSettingsSelectionKey)
        defaults.synchronize()
        
        var tipPct = defaults.doubleForKey(kDGSettingsTipPctStepperKey)
        
        var tipAmt:Double, finalTotal:Double, newTipPct:Double
        
        if roundingSelection.selectedSegmentIndex == Rounding.RoundedTip.rawValue {
            (tipAmt, finalTotal, newTipPct) = tipCalc.calcRoundedTipFrom(TipPct: tipPct / 100.0)
            tipPct = newTipPct * 100.0
        } else if roundingSelection.selectedSegmentIndex == Rounding.RoundedTotal.rawValue {
            (tipAmt, finalTotal, newTipPct) = tipCalc.calcRoundedTotalFrom(TipPct: tipPct / 100.0)
            tipPct = newTipPct * 100.0
        } else {
            (tipAmt, finalTotal) = tipCalc.calcTipWith(TipPct: Double(tipPct) / 100.0)
        }
        
        let tipPctStr = tipPct.format(".0")
        let taxPctStr = (tipCalc.taxPct * 100.0).format(".0")
        // sub, tax, reciept, tip, total
        outputlabels[0] = ("Subtotal:", String(format: "$%0.2f", tipCalc.subtotal))
        outputlabels[1] = ("Tax Amount (\(taxPctStr)%):", String(format: "$%0.2f", tipCalc.taxAmt))
        outputlabels[2] = ("Reciept Total:", String(format: "$%0.2f", tipCalc.total))
        outputlabels[3] = ("Tip Amount (\(tipPctStr)%): ", String(format: "$%0.2f", tipAmt))
        outputlabels[4] = ("Final Total:", String(format: "$%0.2f", finalTotal))

        tipTableView.reloadData()
    }
    
    @IBAction func taxPercentageChanged(sender : AnyObject) {
        tipCalc.taxPct = Double(round(taxPctSlider.value) / 100.0)
        defaults.setDouble(tipCalc.taxPct, forKey: kDGSettingsCalcTaxPctKey)
        defaults.synchronize()
        refreshUI()
    }
    
    @IBAction func stepperValueChanged(sender: AnyObject) {
        //tipPct = Int(round(tipPctStepper.value))
        defaults.setDouble(tipPctStepper.value, forKey: kDGSettingsTipPctStepperKey)
        defaults.synchronize()
        refreshUI()
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        totalTextField.resignFirstResponder()
    }
    
    func refreshUI() {
        totalTextField.text = String(format: "%0.2f", tipCalc.total)
        taxPctSlider.value = Float(tipCalc.taxPct * 100)

        taxPctLabel.text = "Tax Percentage (\(Int(floor(taxPctSlider.value)))%):"
        tipPctLabel.text = "Tip Percentage (\(Int(tipPctStepper.value))%):"
        
        defaults.setObject(totalTextField.text, forKey: kDGSettingsTotalTextKey)
        defaults.setFloat(taxPctSlider.value, forKey: kDGSettingsTaxSliderKey)
        defaults.setObject(taxPctLabel.text, forKey: kDGSettingsTaxLabelKey)
        defaults.setObject(tipPctLabel.text, forKey: kDGSettingsTipPctLabelKey)
        defaults.synchronize()
        
        tipTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputlabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tipTableView.dequeueReusableCellWithIdentifier("Total Detail Cell") as TipTotalCell
        if let (title, amount) = outputlabels[indexPath.row] as (String, String)? {
            cell.titleLabel!.text = title
            cell.numberLabel!.text = amount
        }
        return cell
    }
    
}

