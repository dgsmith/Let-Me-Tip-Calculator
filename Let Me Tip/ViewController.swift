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
    @IBOutlet weak var taxAmountTextField: UITextField!
    @IBOutlet weak var tipPercentageTextField: UITextField!
    @IBOutlet weak var calculationMethodPicker: UISegmentedControl!
    
    @IBOutlet weak var subtotalOutputLabel: UILabel!
    @IBOutlet weak var taxAmountOutputLabel: UILabel!
    @IBOutlet weak var taxPercentageOutputLabel: UILabel!
    @IBOutlet weak var receiptTotalOutputLabel: UILabel!
    @IBOutlet weak var tipAmountOutputLabel: UILabel!
    @IBOutlet weak var tipPercentageOutputLabel: UILabel!
    @IBOutlet weak var finalTotalOutputLabel: UILabel!
    
    @IBOutlet weak var taxAmountStackView: UIStackView!
    @IBOutlet weak var taxPercentageStackView: UIStackView!
    
    @IBOutlet weak var emptySpaceView: UIView!
    
    var tipPresenter: TipViewPresenter!
    
    var state: TipViewState
    var taxInputMethod: TaxInputMethod
    
    var emptySpaceHeight: CGFloat?
    
    // MARK: -
    // MARK: Initializer
    required init?(coder aDecoder: NSCoder) {
        state = .idle
        taxInputMethod = .taxPercentage
        
        super.init(coder: aDecoder)
    }
    
    // MARK: -
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
        
        taxAmountTextField.layer.borderWidth = 1.0
        taxAmountTextField.layer.borderColor = blueColor
        taxAmountTextField.layer.cornerRadius = 4.0
        taxAmountTextField.layer.masksToBounds = true
        
        taxAmountStackView.alpha = 0.3
        taxPercentageStackView.alpha = 1.0
        
        tipPercentageTextField.layer.borderWidth = 1.0
        tipPercentageTextField.layer.borderColor = blueColor
        tipPercentageTextField.layer.cornerRadius = 4.0
        tipPercentageTextField.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        let taxAmountTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.taxAmountTapped(_:)))
        taxAmountStackView.addGestureRecognizer(taxAmountTap)
        
        let taxPercentageTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.taxPercentageTapped(_:)))
        taxPercentageStackView.addGestureRecognizer(taxPercentageTap)
        
        tipPresenter.update(withInputs: nil) { data in
            self.setDisplay(data: data)
        }
    }
    
    // MARK: -
    // MARK: Keyboard Management
    func keyboardWillShow(_ notification: Notification) {
        guard state != .editing else { return }
        state = .keyboardMoving
        
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        emptySpaceHeight = emptySpaceView.bounds.height
        let amountToMoveView = keyboardSize.height - (emptySpaceHeight ?? 0)
        
        view.frame.size.height -= (emptySpaceHeight ?? 0)
        view.frame.origin.y -= amountToMoveView
    }
    
    func keyboardWasShown(_ notification: Notification) {
        state = .editing
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard state == .editing else { return }
        state = .keyboardMoving
        
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let amountToMoveView = keyboardSize.height - (emptySpaceHeight ?? 0)
        
        view.frame.size.height += (emptySpaceHeight ?? 0)
        view.frame.origin.y += amountToMoveView
        
        state = .idle
    }

    // MARK: -
    // MARK: Actions
    @IBAction func calculateTapped(_ sender: AnyObject) {
        if state != .keyboardMoving {
            view.endEditing(true)
            
            recalculate()
        }
    }
    
    @IBAction func viewTapped(_ sender: AnyObject) {
        if state != .keyboardMoving {
            view.endEditing(true)
            
            recalculate()
        }
    }
    
    func taxAmountTapped(_ sender: UITapGestureRecognizer) {
        if !taxAmountTextField.isEnabled {
            changeTaxInputMethod()
        }
    }
    
    func taxPercentageTapped(_ sender: UITapGestureRecognizer) {
        if !taxPercentageTextField.isEnabled {
            changeTaxInputMethod()
        }
    }
    
    func changeTaxInputMethod() {
        if taxInputMethod == .taxPercentage {
            taxInputMethod = .taxAmount
        } else if taxInputMethod == .taxAmount {
            taxInputMethod = .taxPercentage
        }
        
        setTaxInfo()
        
        let data = ["taxInputMethod": NSNumber(value: taxInputMethod.rawValue)]
        tipPresenter.update(withInputs: data, completion: nil)
    }
    
    func setTaxInfo() {
        taxAmountTextField.isEnabled = taxInputMethod == .taxAmount ? true : false
        taxPercentageTextField.isEnabled = taxInputMethod == .taxPercentage ? true : false
        
        taxAmountStackView.alpha = taxInputMethod == .taxAmount ? 1.0 : 0.3
        taxPercentageStackView.alpha = taxInputMethod == .taxPercentage ? 1.0 : 0.3
    }
    
    @IBAction func roundingValueChanged(_ sender: AnyObject) {
        // Only live update if we're not currently entering a value
        if state != .editing {
            recalculate()
        }
    }
    
    // MARK: -
    // MARK: Calculations
    func recalculate() {
        guard let receiptTotalString = receiptTotalTextField.text,
            let taxPercentageString = taxPercentageTextField.text,
            let taxAmountString = taxAmountTextField.text,
            let tipPercentageString = tipPercentageTextField.text else { return }
        
        if let receiptTotal = decimalFormatter.number(from: receiptTotalString),
            let taxPercentage = taxFormatter.number(from: taxPercentageString),
            let taxAmount = decimalFormatter.number(from: taxAmountString),
            let tipPercentage = tipFormatter.number(from: tipPercentageString) {
            
            var data: [String: AnyObject]
            if taxInputMethod == .taxPercentage {
                data = [
                    "receiptTotal": receiptTotal,
                    "taxPercentage": taxPercentage,
                    "tipPercentage": tipPercentage,
                    "calculationMethod": NSNumber(value: calculationMethodPicker.selectedSegmentIndex)
                ]
            } else {
                data = [
                    "receiptTotal": receiptTotal,
                    "taxAmount": taxAmount,
                    "tipPercentage": tipPercentage,
                    "calculationMethod": NSNumber(value: calculationMethodPicker.selectedSegmentIndex)
                ]
            }
            
            tipPresenter.update(withInputs: data) { data in
                self.setDisplay(data: data)
            }
        }
    }
    
    func setDisplay(data: [String: AnyObject]) {
        DispatchQueue.main.async {
            if let subtotal                 = data["subtotal"] as? NSNumber,
                let taxPercentage           = data["taxPercentage"] as? NSNumber,
                let taxAmount               = data["taxAmount"] as? NSNumber,
                let receiptTotal            = data["receiptTotal"] as? NSNumber,
                let tipPercentage           = data["tipPercentage"] as? NSNumber,
                let tipAmount               = data["tipAmount"] as? NSNumber,
                let finalTotal              = data["finalTotal"] as? NSNumber,
                let calculationMethodRaw    = data["calculationMethod"] as? NSNumber,
                let taxInputMethod          = data["taxInputMethod"] as? NSNumber {
                
                self.receiptTotalTextField.text = self.decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                self.taxPercentageTextField.text = self.taxFormatter.string(from: taxPercentage) ?? "0.000%"
                self.taxAmountTextField.text = self.decimalFormatter.string(from: taxAmount) ?? "$0.00"
                self.tipPercentageTextField.text = self.tipFormatter.string(from: tipPercentage) ?? "0.00%"
                self.calculationMethodPicker.selectedSegmentIndex = calculationMethodRaw.intValue
                
                self.subtotalOutputLabel.text = self.decimalFormatter.string(from: subtotal) ?? "$0.00"
                self.taxAmountOutputLabel.text = self.decimalFormatter.string(from: taxAmount) ?? "$0.00"
                self.taxPercentageOutputLabel.text = "Tax (\(self.taxFormatter.string(from: taxPercentage) ?? "0.000%")):"
                self.receiptTotalOutputLabel.text = self.decimalFormatter.string(from: receiptTotal) ?? "$0.00"
                self.tipAmountOutputLabel.text = self.decimalFormatter.string(from: tipAmount) ?? "$0.00"
                self.tipPercentageOutputLabel.text = "Tip (\(self.tipFormatter.string(from: tipPercentage) ?? "0.00%")):"
                self.finalTotalOutputLabel.text = self.decimalFormatter.string(from: finalTotal) ?? "$0.00"
                
                self.taxInputMethod = TaxInputMethod(rawValue: taxInputMethod.intValue) ?? .taxPercentage
                self.setTaxInfo()
            }
        }
        
    }

}

//MARK: -
//MARK: UITexField delegate methods
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == taxPercentageTextField || textField == tipPercentageTextField {
            textField.text = (textField.text! == "" ? "0" : textField.text!) + "%"
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == receiptTotalTextField || textField == taxAmountTextField {
            if let _ = decimalFormatter.number(from: textField.text ?? "") {
                return true
            }
        } else {
            if let _ = tipFormatter.number(from: (textField.text ?? "") + "%") {
                return true
            }
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == receiptTotalTextField || textField == taxAmountTextField {
            // update the string in the text input
            let currentString = NSMutableString(string: textField.text ?? "")
            currentString.replaceCharacters(in: range, with: string)
            
            // strip out decimal and dollar sign
            currentString.replaceOccurrences(of: "$", with: "", options: .literal, range: NSMakeRange(0, currentString.length))
            currentString.replaceOccurrences(of: ".", with: "", options: .literal, range: NSMakeRange(0, currentString.length))
            
            // generate a new string
            let currentValue = currentString.intValue
            let newString = String(format: "$%.2f", Double(currentValue) / 100.0)
            textField.text = newString
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == receiptTotalTextField || textField == taxAmountTextField {
            textField.text = "$0.00"
        } else {
            textField.text = ""
        }
    }
    
}
