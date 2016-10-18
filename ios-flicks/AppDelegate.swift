//
//  AppDelegate.swift
//  ios-flicks
//
//  Created by Savio Tsui on 10/15/16.
//  Copyright © 2016 Savio Tsui. All rights reserved.
//

import SwiftIconFont
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Now Playing
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "com.iosflicks.NavigationController") as! UINavigationController
        vc1.tabBarItem.title = "Now Playing"
        vc1.tabBarItem.icon(from: .FontAwesome, code: "film", imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        let vc1MovieController = vc1.viewControllers.first as! MoviesViewController
        vc1MovieController.apiAction = "now_playing"
        vc1MovieController.navigationTitle = "Now Playing"
        
        // Popular
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "com.iosflicks.NavigationController") as! UINavigationController
        vc2.tabBarItem.title = "Popular"
        vc2.tabBarItem.icon(from: .FontAwesome, code: "trophy", imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        let vc2MovieController = vc1.viewControllers.first as! MoviesViewController
        vc2MovieController.apiAction = "popular"
        vc2MovieController.navigationTitle = "Popular"
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [vc1, vc2]
        tabBarController.selectedIndex = 0
        tabBarController.selectedViewController = tabBarController.viewControllers?[0]
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

