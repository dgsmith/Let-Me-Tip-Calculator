//
//  AppDelegate.swift
//  TipTest
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import UIKit
import PinpointKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private static let pinpointKit = PinpointKit(feedbackRecipients: ["feedback@graysonsmith.me"])
    var window: UIWindow? = ShakeDetectingWindow(frame: UIScreen.main.bounds, delegate: AppDelegate.pinpointKit)
    
    var presenter: TipViewPresenter!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        let navController = window!.rootViewController as! UINavigationController
        let view = navController.topViewController as! ViewController
        
        if let defaults = UserDefaults(suiteName: "group.Let-Me-Tip"),
            let tipData = defaults.object(forKey: "tipData") as? [String:AnyObject],
            let model = TipCalculatorModel(propertyListRepresentation: tipData) {
            presenter = TipPresenter(tipCalculatorModel: model)
            view.tipPresenter = presenter
        } else {
            let model = TipCalculatorModel(total: 32.78, tipPercentage: 0.18)
            presenter = TipPresenter(tipCalculatorModel: model)
            view.tipPresenter = presenter
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //println("In applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

