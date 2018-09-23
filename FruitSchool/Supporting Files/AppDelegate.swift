//
//  AppDelegate.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 1..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import KakaoOpenSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .main
        /**
         * 1. 로그인 안되어 있으면 로그인이 루트 뷰 컨트롤러
         * 2. 로그인 되어 있으면,
         * 2-1. 입학증서 확인 버튼을 누르지 않았으면 튜토리얼이 루트 뷰 컨트롤러
         * 2-2. 입학증서 확인 버튼을 이전에 눌렀다면 탭 바 컨트롤러가 루트 뷰 컨트롤러
        */
        let controller = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        UIApplication.shared.isStatusBarHidden = false
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
// MARK: - KakaoTalk Login
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return false
    }
}
