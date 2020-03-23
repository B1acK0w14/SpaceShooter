//
//  AppDelegate.swift
//  SpaceShooter
//
//  Created by David Penagos on 23/03/20.
//  Copyright © 2020 David Penagos. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.extendSplashScreenPresentation()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    private func extendSplashScreenPresentation(){
        // Get a refernce to LaunchScreen.storyboard
        let launchStoryBoard = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
        // Get the splash screen controller
        let splashController = launchStoryBoard.instantiateViewController(withIdentifier: "splashController")
        // Assign it to rootViewController
        self.window?.rootViewController = splashController
        self.window?.makeKeyAndVisible()
        // Setup a timer to remove it after n seconds
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
    }
    
    @objc private func dismissSplashController() {
        // Get a refernce to Main.storyboard
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        // Get initial viewController
        let initController = mainStoryBoard.instantiateViewController(withIdentifier: "initController")
        // Assign it to rootViewController
        self.window?.rootViewController = initController
        self.window?.makeKeyAndVisible()
    }
}



