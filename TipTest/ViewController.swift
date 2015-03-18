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

let kDGSettingsTotalTextKey  = "TotalTextKey"
let kDGSettingsTaxSliderKey  = "TaxSliderKey"
let kDGSettingsTaxLabelKey   = "TaxLabelKey"
let kDGSettingsSelectionKey  = "SelectionKey"
let kDGSettingsCalcTotalKey  = "CalcTotalKey"
let kDGSettingsCalcTaxPctKey = "CalcTaxPctKey"

class ViewController: UIViewController {
    
    @IBOutlet var totalTextField : UITextField!
    @IBOutlet var taxPctSlider : UISlider!
    @IBOutlet var taxPctLabel : UILabel!
    @IBOutlet var resultsTextView : UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundingSelection: UISegmentedControl!
    @IBOutlet var lowTipDisplay: UITextView!
    @IBOutlet var medTipDisplay: UITextView!
    @IBOutlet var highTipDisplay: UITextView!
    
    enum Rounding : Int {
        case RoundedTotal = 0, None, RoundedTip
    }
    
    let tipCalc = TipCalculatorModel(total: 32.78, taxPct: 0.06)
    var possibleTips = Dictionary<Int, (tipAmt:Double, total:Double)>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var defaults = NSUserDefaults.standardUserDefaults()
        
        totalTextField.text                    = defaults.stringForKey(kDGSettingsTotalTextKey)
        taxPctSlider.value                     = defaults.floatForKey(kDGSettingsTaxSliderKey)
        taxPctLabel.text                       = defaults.stringForKey(kDGSettingsTaxLabelKey)
        roundingSelection.selectedSegmentIndex = defaults.integerForKey(kDGSettingsSelectionKey)
        tipCalc.total                          = defaults.doubleForKey(kDGSettingsCalcTotalKey)
        tipCalc.taxPct                         = defaults.doubleForKey(kDGSettingsCalcTaxPctKey)
        
        lowTipDisplay.text = "Bill:\t\t$X.XX\nTax:\t\t$X.XX\nSubtotal:\t$X.XX\nTip:\t\t$X.XX\nTotal:\t$X.XX"
        medTipDisplay.text = "Bill:\t\t$X.XX\nTax:\t\t$X.XX\nSubtotal:\t$X.XX\nTip:\t\t$X.XX\nTotal:\t$X.XX"
        highTipDisplay.text = "Bill:\t\t$X.XX\nTax:\t\t$X.XX\nSubtotal:\t$X.XX\nTip:\t\t$X.XX\nTotal:\t$X.XX"
        
        lowTipDisplay.layer.borderWidth = 3.0
        lowTipDisplay.layer.borderColor = UIColor.lightGrayColor().CGColor
        lowTipDisplay.layer.cornerRadius = 8
        
        medTipDisplay.layer.borderWidth = 3.0
        medTipDisplay.layer.borderColor = UIColor.lightGrayColor().CGColor
        medTipDisplay.layer.cornerRadius = 8
        
        highTipDisplay.layer.borderWidth = 3.0
        highTipDisplay.layer.borderColor = UIColor.lightGrayColor().CGColor
        highTipDisplay.layer.cornerRadius = 8
        refreshUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateTapped(sender : AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        totalTextField.resignFirstResponder()
        
        tipCalc.total = Double((totalTextField.text as NSString).doubleValue)
        defaults.setDouble(tipCalc.total, forKey: kDGSettingsCalcTotalKey)
        defaults.setInteger(roundingSelection.selectedSegmentIndex, forKey: kDGSettingsSelectionKey)
        
        if roundingSelection.selectedSegmentIndex == Rounding.RoundedTip.rawValue {
            possibleTips = tipCalc.returnRoundedTipPossibleTips()
        } else if roundingSelection.selectedSegmentIndex == Rounding.RoundedTotal.rawValue {
            possibleTips = tipCalc.returnRoundedTotalPossibleTips()
        } else {
            possibleTips = tipCalc.returnExactPossibleTips()
        }
        
        var i = 0
        for (tipPct, possibleTip) in Array(possibleTips).sorted({$0.0 < $1.0}) {
            
            let bill     = tipCalc.subtotal
            let tax      = bill * tipCalc.taxPct
            let subtotal = bill + tax
            
            let billString     = NSString(format: "Bill:\t\t$%0.2f", bill)
            let taxString      = NSString(format: "\nTax:\t\t$%0.2f", tax)
            let subtotalString = NSString(format: "\nSubtotal:\t$%0.2f", subtotal)
            let tipPctString   = NSString(format: "\nTip %%:\t%d%%", tipPct)
            let tip            = NSString(format: "\nTip:\t\t$%0.2f", possibleTip.tipAmt)
            let total          = NSString(format: "\nTotal:\t$%0.2f", possibleTip.total)
            
            switch i {
            case 0:
                lowTipDisplay.text  = billString + taxString + subtotalString + tipPctString + tip + total
            case 1:
                medTipDisplay.text  = billString + taxString + subtotalString + tipPctString + tip + total
            case 2:
                highTipDisplay.text = billString + taxString + subtotalString + tipPctString + tip + total
            default: break
            }
            i++
        }
    }
    
    @IBAction func taxPercentageChanged(sender : AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        tipCalc.taxPct = Double(round(taxPctSlider.value) / 100.0)
        defaults.setDouble(tipCalc.taxPct, forKey: kDGSettingsCalcTaxPctKey)
        refreshUI()
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        totalTextField.resignFirstResponder()
    }
    
    func refreshUI() {
        var defaults = NSUserDefaults.standardUserDefaults()
        
        totalTextField.text = String(format: "%0.2f", tipCalc.total)
        taxPctSlider.value = Float(tipCalc.taxPct * 100)
        taxPctLabel.text = "Tax Percentage (\(Int(floor(taxPctSlider.value)))%)"
        
        defaults.setObject(totalTextField.text, forKey: kDGSettingsTotalTextKey)
        defaults.setFloat(taxPctSlider.value, forKey: kDGSettingsTaxSliderKey)
        defaults.setObject(taxPctLabel.text, forKey: kDGSettingsTaxLabelKey)
        defaults.synchronize()
    }
    
}

