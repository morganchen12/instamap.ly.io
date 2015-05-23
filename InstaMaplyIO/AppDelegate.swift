//
//  AppDelegate.swift
//  InstaMaplyIO
//
//  Created by Morgan Chen on 5/23/15.
//  Copyright (c) 2015 Morgan Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapController: MapController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        if let mapController = self.mapController {
            mapController.drawMap()
            UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
            mapController.startUpdatingLocationInBackground()
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        if let mapController = self.mapController {
            mapController.stopUpdatingLocationInBackground()
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

