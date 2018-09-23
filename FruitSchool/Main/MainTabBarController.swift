//
//  MainTabBarController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 23..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        guard let firstController = UIViewController.instantiate(storyboard: "Home", identifier: "HomeNavigationController") else { return }
        let firstTabBar = UITabBarItem(title: "홈", image: nil, tag: 0)
        firstController.tabBarItem = firstTabBar
        guard let secondController = UIViewController.instantiate(storyboard: "FruitBook", identifier: "FruitBookNavigationController") else { return }
        let secondTabBar = UITabBarItem(title: "교과서", image: nil, tag: 1)
        secondController.tabBarItem = secondTabBar
        guard let thirdController = UIViewController.instantiate(storyboard: "GuideBook", identifier: "GuideBookNavigationController") else { return }
        let thirdTabBar = UITabBarItem(title: "도감", image: nil, tag: 2)
        thirdController.tabBarItem = thirdTabBar
        viewControllers = [firstController, secondController, thirdController]
    }
}
