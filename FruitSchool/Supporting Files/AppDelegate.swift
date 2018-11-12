//
//  AppDelegate.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 1..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .main
        let controller: UIViewController?
        if UserRecord.fetch().count == 0 {
            controller = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString)
        } else {
            controller = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController")
        }
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        // 내비게이션바 투명
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
