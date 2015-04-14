//
//  InfoViewController.swift
//  Let Me Tip
//
//  Created by Grayson Smith on 4/3/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import UIKit
import StoreKit

class InfoViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let defaults = NSUserDefaults(suiteName: "group.Let-Me-Tip")!
    let noAdsKey = "noAds"
    var productID: NSString?
    
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    
    override func viewDidLoad() {
        productID = "com.grayson.Let_Me_Tip.remove_ads"
        super.viewDidLoad()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        // check if purchased
        if let noAds = defaults.boolForKey(noAdsKey) as Bool? {
            if noAds {
                //hide purchase button
                removeAdsButton.enabled = false
                restorePurchasesButton.enabled = false
            } else {
                removeAdsButton.enabled = true
                restorePurchasesButton.enabled = true
            }
        }
    }
    
    func buyProduct(product: SKProduct) {
        var payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("Fetching products")
        
        var count = response.products.count
        if count > 0 {
            if let validProduct = response.products[0] as? SKProduct {
                if validProduct.productIdentifier == self.productID {
                    self.buyProduct(validProduct)
                }
            }
        } else {
            println("No products found")
        }
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        NSLog(error.description)
        println("Error fetching product information")
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("Received payment transaction response from Apple")
        
        for transaction in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .Purchased, .Restored:
                    println("Product purchased")
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    defaults.setBool(true, forKey: noAdsKey)
                    defaults.synchronize()
                    removeAdsButton.enabled = false
                    restorePurchasesButton.enabled = false
                case .Failed:
                    println("Purchase failed")
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func InfoViewFinished(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func restorePurchases(sender: AnyObject) {
        println("About to restore products")
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        } else {
            println("Can't make purchases")
        }
    }
    
    @IBAction func removeAds(sender: AnyObject) {
        println("About to fetch products")
        // check if we're allowed to make the purchase
        if SKPaymentQueue.canMakePayments() {
            var productID = Set(arrayLiteral: self.productID!)
            var productsRequest = SKProductsRequest(productIdentifiers: productID)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            println("Can't make purchases")
        }
    }
}
