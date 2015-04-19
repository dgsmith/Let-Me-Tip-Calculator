//
//  AppDelegate.swift
//  TipTest
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import UIKit
import TipCalcKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var task: UIBackgroundTaskIdentifier!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        self.task = UIApplication.sharedApplication().beginBackgroundTaskWithName("Calc Tip", expirationHandler: {
                self.endBackgroundTask()
        })
        
        if let tipInfo = userInfo?["tipInfo"] as? [Dictionary<String,String>] {
            if let roundingInfo = userInfo?["roundingInfo"] as? Int {
                if tipInfo[0].keys.array[0] == "Receipt Total" {
                    let total = (tipInfo[0].values.array[0].stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString).doubleValue
                    let taxPct = (tipInfo[1].values.array[0].stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString).doubleValue / 100.0
                    let tipPct = (tipInfo[2].values.array[0].stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil) as NSString).doubleValue / 100.0
                    let tipCalc = TipCalculatorModel(total: total, taxPct: taxPct)
                    var tipAmt:Double, finalTotal:Double, newTipPct:Double
                    switch roundingInfo {
                    case 1: // no rounding
                        (tipAmt, finalTotal) = tipCalc.calcTipWith(TipPct: tipPct)
                        newTipPct = tipPct
                    case 2: // rounded tip
                        (tipAmt, finalTotal, newTipPct) = tipCalc.calcRoundedTipFrom(TipPct: tipPct)
                    case 0: // rounded total
                        (tipAmt, finalTotal, newTipPct) = tipCalc.calcRoundedTotalFrom(TipPct: tipPct)
                    default:
                        NSLog("incorrect rounding info!")
                        (tipAmt, finalTotal) = tipCalc.calcTipWith(TipPct: tipPct)
                        newTipPct = tipPct
                    }
                    
                    
                    let tipRows: [Dictionary<String,String>] = [
                        ["Receipt Total":"$\(total)"],
                        ["Tax Percentage":"\(Int(round(taxPct * 100.0)))" + "%"],
                        ["Tip Percentage":String(format: "%2d", Int(round(newTipPct * 100.0))) + "%"],
                        ["Tip Amount":"$" + tipAmt.format("0.2")],
                        ["Total+Tip":"$" + finalTotal.format("0.2")],
                        ["subtotal":String(format: "$%0.2f", tipCalc.subtotal)],
                        ["taxAmt":String(format: "$%0.2f", tipCalc.taxAmt)]
                    ]
                    reply(["tipData":NSKeyedArchiver.archivedDataWithRootObject(tipRows)])
                    return
                }
            }
            
        }
        if let divideString = userInfo?["divide"] as? String {
            if let splitNum = userInfo?["by"] as? Int {
                let cleanString1 = divideString.stringByReplacingOccurrencesOfString("$", withString: "")
                let cleanString2 = cleanString1.stringByReplacingOccurrencesOfString(".", withString: "")
                if let divideNum = cleanString2.toInt() {
                    let newNumInt = divideNum / splitNum
                    let newNum = Double(newNumInt) / 100.0
                    let newString = String(format: "$%.2f", newNum)
                    reply(["divided":NSKeyedArchiver.archivedDataWithRootObject(newString)])
                    return
                }
            }
        }
        reply([:])
        
        //self.endBackgroundTask()
    }
    
    func endBackgroundTask() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            UIApplication.sharedApplication().endBackgroundTask(self.task)
        }
    }
    
}

