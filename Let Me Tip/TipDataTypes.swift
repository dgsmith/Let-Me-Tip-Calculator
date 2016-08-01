//
//  TipDataTypes.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/16/16.
//  Copyright © 2016 Grayson Smith. All rights reserved.
//

import UIKit
import WatchKit

// MARK: Enums
enum TipCalculationMethod: Int {
    case roundedTotal = 0
    case noRounding
    case roundedTip
}

enum TipCalculationError: ErrorProtocol {
    case receiptParseError
    case taxParseError
    case tipParseError
}

enum TipViewState {
    case idle
    case editing
    case keyboardMoving
}

// MARK: -
// MARK: TipViews
protocol TipView: class {
    var decimalFormatter: NumberFormatter { get }
    var taxFormatter: NumberFormatter { get }
    var tipFormatter: NumberFormatter { get }
}

extension TipView {
    var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var taxFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 3
        return formatter
    }
    
    var tipFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

#if os(watchOS)
class WatchTipView: WKInterfaceController, TipView {
    @IBOutlet var wholeNumberPicker: WKInterfacePicker!
    @IBOutlet var fractionalNumberPicker: WKInterfacePicker!
    @IBOutlet var tipAmountTotalLabel: WKInterfaceLabel!
    @IBOutlet var finalTotalLabel: WKInterfaceLabel!
    var tipPresenter: TipViewPresenter?
    lazy var currentWholeNumberIndex = 0
    lazy var currentFractionalNumberIndex = 0
    lazy var updated = false
    
    override func awake(withContext context: AnyObject?) {
        tipPresenter = TipPresenter.shared
    }
    override func willActivate() {
        tipPresenter?.update(withInputs: nil) { data in
            setInitialDisplay(data: data)
        }
    }
    @IBAction func wholeNumberPickerValueUpdated(_ value: Int) {
        currentWholeNumberIndex = value
    }
    @IBAction func fractionalNumberPickerValueUpdated(_ value: Int) {
        currentFractionalNumberIndex = value
    }
    /// Subclass must override -- implementation does nothing
    func setInitialDisplay(data: [String: AnyObject]) {}
    
    func updateDisplay(data: [String: AnyObject]) {
        if let tipAmount    = data["tipAmount"] as? Double,
            let finalTotal  = data["finalTotal"] as? Double {
            
            DispatchQueue.main.async {
                self.tipAmountTotalLabel.setText(self.decimalFormatter.string(from: tipAmount) ?? "$0.00")
                self.finalTotalLabel.setText(self.decimalFormatter.string(from: finalTotal) ?? "$0.00")
            }
        }
    }
    func setMenuItems(withCalculationMethod method: TipCalculationMethod) {
        clearAllMenuItems()
        switch method {
        case .roundedTotal:
            addMenuItem(with: .decline, title: "No Rounding", action: #selector(WatchTipView.noRoundingSelected))
            addMenuItem(with: .accept, title: "Round Total", action: #selector(WatchTipView.roundedTotalSelected))
            addMenuItem(with: .decline, title: "Round Tip", action: #selector(WatchTipView.roundedTipSelected))
        case .noRounding:
            addMenuItem(with: .accept, title: "No Rounding", action: #selector(WatchTipView.noRoundingSelected))
            addMenuItem(with: .decline, title: "Round Total", action: #selector(WatchTipView.roundedTotalSelected))
            addMenuItem(with: .decline, title: "Round Tip", action: #selector(WatchTipView.roundedTipSelected))
        case .roundedTip:
            addMenuItem(with: .decline, title: "No Rounding", action: #selector(WatchTipView.noRoundingSelected))
            addMenuItem(with: .decline, title: "Round Total", action: #selector(WatchTipView.roundedTotalSelected))
            addMenuItem(with: .accept, title: "Round Tip", action: #selector(WatchTipView.roundedTipSelected))
        }
    }
    @objc func roundedTotalSelected() {
        let calculationMethod = TipCalculationMethod.roundedTotal
        let data = ["calculationMethod": calculationMethod.rawValue]
        setMenuItems(withCalculationMethod: calculationMethod)
        tipPresenter?.update(withInputs: data, withCompletion: { (data) in
            updateDisplay(data: data)
        })
    }
    @objc func noRoundingSelected() {
        let calculationMethod = TipCalculationMethod.noRounding
        let data = ["calculationMethod": calculationMethod.rawValue]
        setMenuItems(withCalculationMethod: calculationMethod)
        tipPresenter?.update(withInputs: data, withCompletion: { (data) in
            updateDisplay(data: data)
        })
    }
    @objc func roundedTipSelected() {
        let calculationMethod = TipCalculationMethod.roundedTip
        let data = ["calculationMethod": calculationMethod.rawValue]
        setMenuItems(withCalculationMethod: calculationMethod)
        tipPresenter?.update(withInputs: data, withCompletion: { (data) in
            updateDisplay(data: data)
        })
    }
}
#endif

// MARK: -
// MARK: TipViewPresenters
protocol TipViewPresenter: class {
    init(tipCalculatorModel: TipCalculatorModel)
    func update(withInputs: [String:AnyObject]?, withCompletion completion: @noescape ([String:AnyObject]) -> Void)
}

protocol PropertyListReadable {
    func propertyListRepresentation() -> [String: AnyObject]
    init? (propertyListRepresentation: [String: AnyObject]?)
}
