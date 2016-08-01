//
//  ViewController.swift
//  TipCalculator
//
//  Created by Grayson Smith on 10/19/14.
//  Copyright (c) 2014 grayson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TipView {
    
    @IBOutlet weak var receiptTotalTextField: UITextField!
    @IBOutlet weak var taxPercentageTextField: UITextField!
    @IBOutlet weak var tipPercentageTextField: UITextField!
    @IBOutlet weak var calculationMethodPicker: UISegmentedControl!
    
    @IBOutlet weak var subtotalOutputLabel: UILabel!
    @IBOutlet weak var taxAmountOutputLabel: UILabel!
    @IBOutlet weak var taxPercentageOutputLabel: UILabel!
    @IBOutlet weak var receiptTotalOutputLabel: UILabel!
    @IBOutlet weak var tipAmountOutputLabel: UILabel!
    @IBOutlet weak var tipPercentageOutputLabel: UILabel!
    @IBOutlet weak var finalTotalOutputLabel: UILabel!
    
    var tipPresenter: TipViewPresenter!
    
    var state: TipViewState
    
    // MARK: Initializer
    required init?(coder aDecoder: NSCoder) {
        state = .idle
        
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
//        let borderColor = UIColor(red: 255.0 / 255.0,
//                                  green: 159.0 / 255.0,
//                                  blue: 51.0 / 255.0,
//                                  alpha: 1.0).CGColor
        
        let blueColor = UIColor(red: 52.0 / 255.0,
                                green: 170.0 / 255.0,
                                blue: 220.0 / 255.0,
                                alpha: 1.0).cgColor
        
        receiptTotalTextField.layer.borderWidth = 1.0
        receiptTotalTextField.layer.borderColor = blueColor
        receiptTotalTextField.layer.cornerRadius = 4.0
        receiptTotalTextField.layer.masksToBounds = true
        
        taxPercentageTextField.layer.borderWidth = 1.0
        taxPercentageTextField.layer.borderColor = blueColor
        taxPercentageTextField.layer.cornerRadius = 4.0
        taxPercentageTextField.layer.masksToBounds = true
        
        tipPercentageTextField.layer.borderWidth = 1.0
        tipPercentageTextField.layer.borderColor = blueColor
        tipPercentageTextField.layer.cornerRadius = 4.0
        tipPercentageTextField.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        tipPresenter.update(withInputs: nil) { data in
            if let subtotal                 = data["subtotal"] as? Double,
                let taxPercentage           = data["taxPercentage"] as? Double,
                let taxAmount               = data["taxAmount"] as? Double,
                let receiptTotal            = data["receiptTotal"] as? Double,
                let tipPercentage           = data["tipPercentage"] as? Double,
                let tipAmount               = data["tipAmount"] as? Double,
                let finalTotal              = data["finalTotal"] as? Double,
                let calculationMethodRaw    = data["calculationMethod"] as? Int {
                
                receiptTotalTextField.text = decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                taxPercentageTextField.text = taxFormatter.string(from: taxPercentage) ?? "0.000%"
                tipPercentageTextField.text = tipFormatter.string(from: tipPercentage) ?? "0.00%"
                calculationMethodPicker.selectedSegmentIndex = calculationMethodRaw
                
                subtotalOutputLabel.text = decimalFormatter.string(from: subtotal) ?? "$0.00"
                taxAmountOutputLabel.text = decimalFormatter.string(from: taxAmount) ?? "$0.00"
                taxPercentageOutputLabel.text = "Tax (\(taxFormatter.string(from: taxPercentage) ?? "0.000%")):"
                receiptTotalOutputLabel.text = decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                tipAmountOutputLabel.text = decimalFormatter.string(from: tipAmount) ?? "$0.00"
                tipPercentageOutputLabel.text = "Tip (\(tipFormatter.string(from: tipPercentage) ?? "0.00%")):"
                finalTotalOutputLabel.text = decimalFormatter.string(from: finalTotal) ?? "$0.00"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func recalculate() {
        guard let receiptTotalString = receiptTotalTextField.text,
            let taxPercentageString = taxPercentageTextField.text,
            let tipPercentageString = tipPercentageTextField.text else { return }
        
        if let receiptTotal = decimalFormatter.number(from: receiptTotalString) as? Double,
            let taxPercentage = taxFormatter.number(from: taxPercentageString) as? Double,
            let tipPercentage = tipFormatter.number(from: tipPercentageString) as? Double {
            let data: [String:AnyObject] = [
                "receiptTotal": receiptTotal,
                "taxPercentage": taxPercentage,
                "tipPercentage": tipPercentage,
                "calculationMethod": calculationMethodPicker.selectedSegmentIndex
            ]
            tipPresenter.update(withInputs: data) { data in
                if let subtotal                 = data["subtotal"] as? Double,
                    let taxPercentage           = data["taxPercentage"] as? Double,
                    let taxAmount               = data["taxAmount"] as? Double,
                    let receiptTotal            = data["receiptTotal"] as? Double,
                    let tipPercentage           = data["tipPercentage"] as? Double,
                    let tipAmount               = data["tipAmount"] as? Double,
                    let finalTotal              = data["finalTotal"] as? Double,
                    let calculationMethodRaw    = data["calculationMethod"] as? Int {
                    
                    receiptTotalTextField.text = decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                    taxPercentageTextField.text = taxFormatter.string(from: taxPercentage) ?? "0.000%"
                    tipPercentageTextField.text = tipFormatter.string(from: tipPercentage) ?? "0.00%"
                    calculationMethodPicker.selectedSegmentIndex = calculationMethodRaw
                    
                    subtotalOutputLabel.text = decimalFormatter.string(from: subtotal) ?? "$0.00"
                    taxAmountOutputLabel.text = decimalFormatter.string(from: taxAmount) ?? "$0.00"
                    taxPercentageOutputLabel.text = "Tax (\(taxFormatter.string(from: taxPercentage) ?? "0.000%")):"
                    receiptTotalOutputLabel.text = decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                    tipAmountOutputLabel.text = decimalFormatter.string(from: tipAmount) ?? "$0.00"
                    tipPercentageOutputLabel.text = "Tip (\(tipFormatter.string(from: tipPercentage) ?? "0.00%")):"
                    finalTotalOutputLabel.text = decimalFormatter.string(from: finalTotal) ?? "$0.00"
                }
            }
        }
    }
    
    // MARK: Keyboard Management
    func keyboardWillShow(_ notification: Notification) {
        guard state != .editing else { return }
        state = .keyboardMoving
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue() {
            state = .keyboardMoving
            if UIDevice.current().userInterfaceIdiom == .phone
                && UIScreen.main().bounds.size.height >= 736.0 {
                view.frame.size.height -= keyboardSize.height
            } else {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWasShown(_ notification: Notification) {
        state = .editing
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard state == .editing else { return }
        state = .keyboardMoving
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue() {
            
            if UIDevice.current().userInterfaceIdiom == .phone
                && UIScreen.main().bounds.size.height >= 736.0 {
                view.frame.size.height += keyboardSize.height
            } else {
                view.frame.origin.y += keyboardSize.height
            }
            
            state = .idle
        }
    }

    // MARK: Actions
    @IBAction func calculateTapped(_ sender : AnyObject) {
        if state != .keyboardMoving {
            view.endEditing(true)
            
            recalculate()
        }
    }
    
    @IBAction func viewTapped(_ sender : AnyObject) {
        if state != .keyboardMoving {
            view.endEditing(true)
            
            recalculate()
        }
    }
    
    @IBAction func roundingValueChanged(_ sender: AnyObject) {
        // Only live update if we're not currently entering a value
        if state != .editing {
            recalculate()
        }
    }
    
}

//MARK: -
//MARK: UITexField delegate methods
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            textField.text = (textField.text! == "" ? "0" : textField.text!) + "%"
        } else {
            textField.text = "$" + (textField.text! == "" ? "0" : textField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            // update the string in the text input
            let currentString = NSMutableString(string: textField.text!)
            currentString.replaceCharacters(in: range, with: string)
            
            // strip out decimal
            currentString.replaceOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: NSMakeRange(0, currentString.length))
            
            // generate a new string
            let currentValue = currentString.intValue
            let newString = String(format: "%.2f", Double(currentValue) / 100.0)
            textField.text = newString
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
}
