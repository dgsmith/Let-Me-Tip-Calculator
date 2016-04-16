//
//  ViewController.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit
import iAd

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var receiptTotalTextField: UITextField!
    @IBOutlet weak var taxPctTextField: UITextField!
    @IBOutlet weak var tipPctTextField: UITextField!
    @IBOutlet weak var tipTableView: UITableView!
    @IBOutlet weak var roundingSelection: UISegmentedControl!
    
    let tipCalc = TipCalculatorModel(total: 32.78, taxPct: 0.06)
    
    var outputlabels:[(String,String)] = []
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    
    let subtotalKey         = "subtotal"
    let receiptTotalKey     = "receiptTotal"
    let taxPctKey           = "taxPct"
    let taxAmtKey           = "taxAmt"
    let tipPctKey           = "tipPct"
    let tipAmtKey           = "tipAmt"
    let tipAndTotalKey      = "tipAndTotal"
    let currentRoundingKey  = "currentRounding"
    
    let totalFormatter: NSNumberFormatter  = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let taxFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    let tipFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        outputlabels.insert(("Subtotal:",       " "), atIndex: 0)
        outputlabels.insert(("Tax Amount:",     " "), atIndex: 1)
        outputlabels.insert(("Receipt Total:",  " "), atIndex: 2)
        outputlabels.insert(("Tip Amount: ",    " "), atIndex: 3)
        outputlabels.insert(("Final Total:",    " "), atIndex: 4)
        
        refreshUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshUI()
    }
    
    //MARK: - UITexField delegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("%", withString: "")
        } else {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString("$", withString: "")
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            textField.text = textField.text! + "%"
        } else {
            textField.text = "$" + textField.text!
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            // update the string in the text input
            let currentString = NSMutableString(string: textField.text!)
            currentString.replaceCharactersInRange(range, withString: string)
            
            // strip out decimal
            currentString.replaceOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: NSMakeRange(0, currentString.length))
            
            // generate a new string
            let currentValue = currentString.intValue
            let newString = String(format: "%.2f", Double(currentValue) / 100.0)
            textField.text = newString
            return false
        }
        return true
    }

    // MARK: - Actions
    @IBAction func calculateTapped(sender : AnyObject) {
        // get the number pad out of the way
        receiptTotalTextField.resignFirstResponder()
        taxPctTextField.resignFirstResponder()
        tipPctTextField.resignFirstResponder()
        /*
        if let int = receiptTotalTextField.text.stringByReplacingOccurrencesOfString(".", withString: "").toInt() as Int? {
            tipCalc.total = Double(int) / 100.0
        }
        defaults.setObject("$" + receiptTotalTextField.text, forKey: receiptTotalKey)
        defaults.setObject(roundingSelection.selectedSegmentIndex, forKey: currentRoundingKey)
        */
        if let tipTotal = totalFormatter.numberFromString(receiptTotalTextField.text!) as? Double {  // total good?
            if let tipPct = tipFormatter.numberFromString(tipPctTextField.text!) as? Double {        // tip good?
                if let taxPct = taxFormatter.numberFromString(taxPctTextField.text!) as? Double {    // tax good?
                    tipCalc.total = tipTotal
                    tipCalc.taxPct = taxPct
                    let taxPctStr = taxPctTextField.text!
                    
                    var tipAmt:Double, finalTotal:Double, newTipPct:Double
                    if roundingSelection.selectedSegmentIndex == 2 {
                        (tipAmt, finalTotal, newTipPct) = tipCalc.calculateRoundedTipAmountFromTipPercentage(tipPct)
                        //tipPct = newTipPct
                    } else if roundingSelection.selectedSegmentIndex == 0 {
                        (tipAmt, finalTotal, newTipPct) = tipCalc.calculateRoundedTotalFromTipPercentage(tipPct)
                        //tipPct = newTipPct
                    } else {
                        (tipAmt, finalTotal) = tipCalc.calculateExactTipWithTipPercentage(tipPct)
                        newTipPct = tipPct
                    }
                    
                    let tipPctStr = tipFormatter.stringFromNumber(newTipPct)!
                    
                    // sub, tax, receipt, tip, total
                    outputlabels[0] = ("Subtotal:", String(format: "$%0.2f", tipCalc.subtotal))
                    outputlabels[1] = ("Tax Amount (\(taxPctStr)):", String(format: "$%0.2f", tipCalc.taxAmt))
                    outputlabels[2] = ("Receipt Total:", String(format: "$%0.2f", tipCalc.total))
                    outputlabels[3] = ("Tip Amount (\(tipPctStr)): ", String(format: "$%0.2f", tipAmt))
                    outputlabels[4] = ("Final Total:", String(format: "$%0.2f", finalTotal))
                    
                    defaults.setObject(receiptTotalTextField.text, forKey: receiptTotalKey)
                    defaults.setObject(roundingSelection.selectedSegmentIndex, forKey: currentRoundingKey)
                    defaults.setObject(outputlabels[0].1, forKey: subtotalKey)
                    defaults.setObject(outputlabels[1].1, forKey: taxAmtKey)
                    defaults.setObject("\(taxPctStr)", forKey: taxPctKey)
                    defaults.setObject("\(tipPctStr)", forKey: tipPctKey)
                    defaults.setObject(outputlabels[3].1, forKey: tipAmtKey)
                    defaults.setObject(outputlabels[4].1, forKey: tipAndTotalKey)
                    
                    defaults.synchronize()
                    refreshUI()
                    tipTableView.reloadData()
                    
                }
            }
        }
        
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        receiptTotalTextField.resignFirstResponder()
        taxPctTextField.resignFirstResponder()
        tipPctTextField.resignFirstResponder()
    }
    
    @IBAction func roundingValueChanged(sender: AnyObject) {
        calculateTapped("hi")
    }
    
    func refreshUI() {
        if let str = defaults.objectForKey(receiptTotalKey) as? String {
            receiptTotalTextField.text = str
            if let dbl = totalFormatter.numberFromString(str) as? Double {
                tipCalc.total = dbl
            }
        } else {
            receiptTotalTextField.text = totalFormatter.stringFromNumber(tipCalc.total)!
        }
        
        if let str = defaults.objectForKey(taxPctKey) as? String {
            taxPctTextField.text = str
            if let dbl = taxFormatter.numberFromString(str) as? Double {
                tipCalc.taxPct = dbl
            }
        } else {
            taxPctTextField.text = tipFormatter.stringFromNumber(tipCalc.taxPct)!
        }
        
        if let str = defaults.objectForKey(tipPctKey) as? String {
            tipPctTextField.text = str
        } else {
            tipPctTextField.text = "15%"
        }
        
        if let rounding = defaults.objectForKey(currentRoundingKey) as? Int {
            roundingSelection.selectedSegmentIndex = rounding
        }
        
    }
    
    // MARK: - UITableViewDataSourceDelegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outputlabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tipTableView.dequeueReusableCellWithIdentifier("Total Detail Cell") as? TipTotalCell {
            if let (title, amount) = outputlabels[indexPath.row] as (String, String)? {
                cell.titleLabel.text = title
                cell.numberLabel.text = amount
                return cell
            } else {
                cell.titleLabel.text = " "
                cell.numberLabel.text = " "
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
}

