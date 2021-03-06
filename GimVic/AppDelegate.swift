//
//  AppDelegate.swift
//  GimVic
//
//  Created by Vid Drobnič on 9/18/16.
//  Copyright © 2016 Vid Drobnič. All rights reserved.
//

import UIKit
import GimVicData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        RootViewController.sharedInstance?.timer?.invalidate()
        RootViewController.sharedInstance?.timer = nil
        
        ChooserData.sharedInstance.save()
        TimetableData.sharedInstance.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        RootViewController.sharedInstance?.setTimer()
    }
    
    func setRootControllerDay() {
        guard let lastOpened =  UserDefaults().object(forKey: UserSettings.lastOpened.rawValue) as? Date else {
            UserDefaults().set(Date(), forKey: UserSettings.lastOpened.rawValue)
            
            if let rootViewController = RootViewController.sharedInstance {
                rootViewController.transitionToDay(rootViewController.startingIndex)
            }
            return
        }
        
        let calendar = Calendar(identifier: .gregorian)
        let lastOpenedDay = calendar.ordinality(of: .day, in: .era, for: lastOpened)!
        let currentDay = calendar.ordinality(of: .day, in: .era, for: Date())!
        if currentDay - lastOpenedDay > 0 {
            UserDefaults().set(Date(), forKey: UserSettings.lastOpened.rawValue)
            
            if let rootViewController = RootViewController.sharedInstance {
                rootViewController.transitionToDay(rootViewController.startingIndex)
            }
        }
    }
    
    func updateChooserData() {
        if let lastUpdatedDate = UserDefaults().object(forKey: UserSettings.lastRefreshedChooserData.rawValue) as? Date {
            if Date().timeIntervalSince(lastUpdatedDate) > 24*3600 {
                ChooserData.sharedInstance.update()
            }
        } else {
            ChooserData.sharedInstance.update()
        }
    }
    
    func updateTimetableData() {
        if let lastUpdatedDate = UserDefaults().object(forKey: UserSettings.lastRefreshedTimetableData.rawValue) as? Date {
            if Date().timeIntervalSince(lastUpdatedDate) > 15*60 {
                TimetableData.sharedInstance.update()
            }
        } else {
            TimetableData.sharedInstance.update()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        RootViewController.sharedInstance?.setDataAgeLabel()
        
        setRootControllerDay()
        updateChooserData()
        updateTimetableData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

