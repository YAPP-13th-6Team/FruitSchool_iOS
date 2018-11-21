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
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .main
        let controller: UIViewController?
        if UserRecord.fetch().count == 0 {
            controller = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString)
        } else {
            let splitViewController = UISplitViewController()
            let master = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController") ?? UIViewController()
            //let detail = UIViewController.instantiate(storyboard: "Book", identifier: "DetailNavigationController") ?? UIViewController()
            let detail = UIViewController.instantiate(storyboard: "Book", identifier: DummyDetailNavigationController.classNameToString) ?? UIViewController()
            splitViewController.viewControllers = [master, detail]
            controller = splitViewController
            //controller = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController")
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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if deviceModel == .iPad {
            return [.landscapeRight]
        } else {
            return [.portrait]
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
