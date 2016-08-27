//
//  AppDelegate.swift
//  TipTest
//
//  Created by Grayson Smith on 3/16/15.
//  Copyright (c) 2015 Grayson Smith. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
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
        
        registerForPushNotifications(application)
        
        Instabug.start(withToken: "52cc5a34042f2351149b9184cd8465ec", invocationEvent: .shake)
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
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        _ = deviceToken.withUnsafeBytes { (pointer: UnsafePointer<CChar>) -> Bool in
            let tokenChars: UnsafePointer<CChar> = pointer
            var tokenString = ""
            
            for i in 0..<deviceToken.count {
                tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
            }
            
            print("Device token: \(tokenString)")
            Instabug.setPushNotificationsEnabled(true)
            
            return true
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        Instabug.setPushNotificationsEnabled(false)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
}

