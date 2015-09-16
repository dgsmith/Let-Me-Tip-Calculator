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
    var productID: String?
    
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
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("Fetching products")
        
        let count = response.products.count
        if count > 0 {
            let validProduct = response.products[0]
            if validProduct == self.productID {
                self.buyProduct(validProduct)
            }
        } else {
            print("No products found")
        }
    }
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        NSLog(error.description)
        print("Error fetching product information")
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received payment transaction response from Apple")
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased, .Restored:
                print("Product purchased")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                defaults.setBool(true, forKey: noAdsKey)
                defaults.synchronize()
                removeAdsButton.enabled = false
                restorePurchasesButton.enabled = false
            case .Failed:
                print("Purchase failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    @IBAction func InfoViewFinished(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func restorePurchases(sender: AnyObject) {
        print("About to restore products")
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        } else {
            print("Can't make purchases")
        }
    }
    
    @IBAction func removeAds(sender: AnyObject) {
        print("About to fetch products")
        // check if we're allowed to make the purchase
        if SKPaymentQueue.canMakePayments() {
            let productID: Set<String> = Set(arrayLiteral: self.productID!)
            let productsRequest = SKProductsRequest(productIdentifiers: productID)
            productsRequest.delegate = self
            productsRequest.start()
        } else {
            print("Can't make purchases")
        }
    }
}
