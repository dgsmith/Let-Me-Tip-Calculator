//
//  InterfaceController.swift
//  TipTest WatchKit Extension
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import WatchKit

enum Rounding : Int {
    case RoundedTotal = 0, None, RoundedTip
}

class InterfaceController: WKInterfaceController {
    
    var tipData: TipData!
    
    @IBOutlet weak var receiptTotalLabel: WKInterfaceLabel!
    @IBOutlet weak var taxPercentabeLabel: WKInterfaceLabel!
    @IBOutlet weak var tipPercentageLabel: WKInterfaceLabel!
    @IBOutlet weak var calculatedTipLabel: WKInterfaceLabel!
    @IBOutlet weak var finalTotalLabel: WKInterfaceLabel!
    
    // MARK: - View lifecycle
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        tipData = TipData()
        
        setLabels()
        setMenuItems()
        
    }
    
    override func didAppear() {
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
        pushControllerWithName("DollarAmountPicker", context: tipData)
    }
    
    @IBAction func setTaxPercentage() {
        pushControllerWithName("TaxPercentagePicker", context: tipData)
    }
    
    @IBAction func setTipPercentage() {
        pushControllerWithName("TipPercentagePicker", context: tipData)
    }
    
    @IBAction func viewCalculationBreakdown() {
        pushControllerWithName("CalculationDetail", context: tipData)
    }
    
    @IBAction func setSplittingOptions() {
        pushControllerWithName("SplittingOptions", context: tipData)
    }
    
    // MARK: - Menu setup
    func setMenuItems() {
        clearAllMenuItems()
        switch tipData.calculationMethod {
        case .NoRounding:
            addMenuItemWithItemIcon(.Accept, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Decline, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Decline, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
        case .RoundedTip:
            addMenuItemWithItemIcon(.Decline, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Accept, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Decline, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
        case .RoundedTotal:
            addMenuItemWithItemIcon(.Decline, title: "Round None", action: #selector(InterfaceController.noRoundingAction))
            addMenuItemWithItemIcon(.Decline, title: "Round Tip", action: #selector(InterfaceController.roundTipAction))
            addMenuItemWithItemIcon(.Accept, title: "Round Total", action: #selector(InterfaceController.roundTotalAction))
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
