//
//  InterfaceController.swift
//  TipTest WatchKit Extension
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit

enum Rounding : Int {
    case roundedTotal = 0, none, roundedTip
}

class InterfaceController: WKInterfaceController {
    
    var tipData: TipData!
    
    @IBOutlet weak var receiptTotalLabel: WKInterfaceLabel!
    @IBOutlet weak var taxPercentabeLabel: WKInterfaceLabel!
    @IBOutlet weak var tipPercentageLabel: WKInterfaceLabel!
    @IBOutlet weak var calculatedTipLabel: WKInterfaceLabel!
    @IBOutlet weak var finalTotalLabel: WKInterfaceLabel!
    
    // MARK: - View lifecycle
    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        
        tipData = TipData()
        
        setLabels()
        setMenuItems()
    }
    
    override func didAppear() {
        // Doing this so when you come back from setting a value, it gets updated!
        setLabels()
    }
    
    func setLabels() {
        receiptTotalLabel.setText(tipData.receiptTotal.text ?? "")
        taxPercentabeLabel.setText(tipData.taxPercentage.text ?? "")
        tipPercentageLabel.setText(tipData.tipPercentage.text ?? "")
        calculatedTipLabel.setText(tipData.tipAmount.text ?? "")
        finalTotalLabel.setText(tipData.finalTotal.text ?? "")
    }
    
    //MARK: - Actions
    @IBAction func setReceiptTotal() {
        pushController(withName: "DollarAmountPicker", context: tipData)
    }
    
    @IBAction func setTaxPercentage() {
        pushController(withName: "TaxPercentagePicker", context: tipData)
    }
    
    @IBAction func setTipPercentage() {
        pushController(withName: "TipPercentagePicker", context: tipData)
    }
    
    @IBAction func viewCalculationBreakdown() {
        pushController(withName: "CalculationDetail", context: tipData)
    }
    
    @IBAction func setSplittingOptions() {
        pushController(withName: "SplittingOptions", context: tipData)
    }
    
    // MARK: - Menu setup
    func setMenuItems() {
        clearAllMenuItems()
        switch tipData.calculationMethod {
        case .NoRounding:
            addMenuItem(with: .accept, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItem(with: .decline, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItem(with: .decline, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
        case .RoundedTip:
            addMenuItem(with: .decline, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItem(with: .accept, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItem(with: .decline, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
        case .RoundedTotal:
            addMenuItem(with: .decline, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItem(with: .decline, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItem(with: .accept, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
        }
    }
    
    func noRoundingAction() {
        tipData.calculationMethod = .NoRounding
        tipData.calculate()
        setMenuItems()
        setLabels()
    }
    
    func roundTipAction() {
        tipData.calculationMethod = .RoundedTip
        tipData.calculate()
        setMenuItems()
        setLabels()
    }
    
    func roundTotalAction() {
        tipData.calculationMethod = .RoundedTotal
        tipData.calculate()
        setMenuItems()
        setLabels()
    }

}
