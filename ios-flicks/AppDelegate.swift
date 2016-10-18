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
        let nowPlayingNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "com.iosflicks.NavigationController") as! UINavigationController
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.icon(from: .FontAwesome, code: "film", imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        let nowPlayingMovieController = nowPlayingNavigationController.viewControllers.first as! MoviesViewController
        nowPlayingMovieController.apiAction = "now_playing"
        nowPlayingMovieController.navigationTitle = "Now Playing"
        nowPlayingMovieController.view.backgroundColor = UIColor.black
        
        // Popular
        let popularNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "com.iosflicks.NavigationController") as! UINavigationController
        popularNavigationController.tabBarItem.title = "Popular"
        popularNavigationController.tabBarItem.icon(from: .FontAwesome, code: "trophy", imageSize: CGSize(width: 20, height: 20), ofSize: 20)
        let popularMovieController = popularNavigationController.viewControllers.first as! MoviesViewController
        popularMovieController.apiAction = "popular"
        popularMovieController.navigationTitle = "Popular"
        popularMovieController.view.backgroundColor = UIColor.black
        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController, popularNavigationController]
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

