//
//  ViewController.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var receiptTotalTextField: UITextField!
    @IBOutlet weak var taxPctTextField: UITextField!
    @IBOutlet weak var tipPctTextField: UITextField!
    @IBOutlet weak var roundingSelection: UISegmentedControl!
    
    @IBOutlet weak var subtotalOutputLabel: UILabel!
    @IBOutlet weak var taxOutputLabel: UILabel!
    @IBOutlet weak var taxPercentageOutputLabel: UILabel!
    @IBOutlet weak var receiptTotalOutputLabel: UILabel!
    @IBOutlet weak var tipOutputLabel: UILabel!
    @IBOutlet weak var tipPercentageOutputLabel: UILabel!
    @IBOutlet weak var finalTotalOutputLabel: UILabel!
    
    var tipData: TipData!
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        let borderColor = UIColor(red: 255.0 / 255.0,
                                  green: 159.0 / 255.0,
                                  blue: 51.0 / 255.0,
                                  alpha: 1.0).CGColor
        
        receiptTotalTextField.layer.borderWidth = 1.0
        receiptTotalTextField.layer.borderColor = borderColor
        receiptTotalTextField.layer.cornerRadius = 4.0
        receiptTotalTextField.layer.masksToBounds = true
        
        taxPctTextField.layer.borderWidth = 1.0
        taxPctTextField.layer.borderColor = borderColor
        taxPctTextField.layer.cornerRadius = 4.0
        taxPctTextField.layer.masksToBounds = true
        
        tipPctTextField.layer.borderWidth = 1.0
        tipPctTextField.layer.borderColor = borderColor
        tipPctTextField.layer.cornerRadius = 4.0
        tipPctTextField.layer.masksToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        loadValues()
        recalculate()
        refreshUI()
    }
    
    // MARK: - Display management
    func loadValues() {
        receiptTotalTextField.text = tipData.receiptTotal.text ?? ""
        taxPctTextField.text = tipData.taxPercentage.text ?? ""
        tipPctTextField.text = tipData.tipPercentage.text ?? ""
        switch tipData.calculationMethod {
        case .NoRounding:
            roundingSelection.selectedSegmentIndex = 1
        case .RoundedTip:
            roundingSelection.selectedSegmentIndex = 2
        case .RoundedTotal:
            roundingSelection.selectedSegmentIndex = 0
        }
    }
    
    func recalculate() {
        let inReceiptTotal = DollarAmount(string: receiptTotalTextField.text!)
        let inTaxPercentage = TaxPercentage(string: taxPctTextField.text!)
        let inTipPercentage = TipPercentage(string: tipPctTextField.text!)
        
        do {
            try tipData.updateDataWithReceiptTotal(inReceiptTotal, taxPercentage: inTaxPercentage, andTipPercentage: inTipPercentage)
        } catch {
            print("Error calculating...\(error)")
        }
    }
    
    func refreshUI() {
        subtotalOutputLabel.text = tipData.subtotal.text ?? ""
        taxOutputLabel.text = tipData.taxAmount.text ?? ""
        taxPercentageOutputLabel.text = "Tax (\(tipData.taxPercentage.text ?? "")):"
        receiptTotalOutputLabel.text = tipData.receiptTotal.text ?? ""
        tipOutputLabel.text = tipData.tipAmount.text ?? ""
        tipPercentageOutputLabel.text = "Tip (\(tipData.tipPercentage.text ?? "")):"
        finalTotalOutputLabel.text = tipData.finalTotal.text ?? ""
    }

    // MARK: - Actions
    @IBAction func calculateTapped(sender : AnyObject) {
        view.endEditing(true)
        recalculate()
        refreshUI()
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        view.endEditing(true)
        recalculate()
        refreshUI()
    }
    
    @IBAction func roundingValueChanged(sender: AnyObject) {
        switch roundingSelection.selectedSegmentIndex {
        case 0:
            tipData.calculationMethod = .RoundedTotal
        case 1:
            tipData.calculationMethod = .NoRounding
        case 2:
            tipData.calculationMethod = .RoundedTip
        default:
            // this shouldn't happen...
            tipData.calculationMethod = .NoRounding
        }
        
        recalculate()
        refreshUI()
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    //MARK: - UITexField delegate methods
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
    
}
