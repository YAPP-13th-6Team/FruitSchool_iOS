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
        guard let firstController = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController") else { return }
        let firstTabBar = UITabBarItem(title: "홈", image: #imageLiteral(resourceName: "tabbarHome"), tag: 0)
        firstController.tabBarItem = firstTabBar
        guard let secondController = UIViewController.instantiate(storyboard: "Community", identifier: "CommunityNavigationController") else { return }
        let secondTabBar = UITabBarItem(title: "커뮤니티", image: #imageLiteral(resourceName: "tabbarCommunity"), tag: 1)
        secondController.tabBarItem = secondTabBar
        guard let thirdController = UIViewController.instantiate(storyboard: "MyPage", identifier: "MyPageNavigationController") else { return }
        let thirdTabBar = UITabBarItem(title: "마이페이지", image: nil, tag: 2)
        thirdController.tabBarItem = thirdTabBar
        viewControllers = [firstController, secondController, thirdController]
    }
}
