//
//  TutorialViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//
// Tutorial 화면을 위한 donald 브랜치 생성

import UIKit

class TutorialViewController: UIPageViewController {

    lazy var pages: [UIViewController] = {
        let dummy = UIViewController()
        let first = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial1ViewController") ?? dummy
        let second = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial2ViewController") ?? dummy
        let third = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial3ViewController") ?? dummy
        let last = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial4ViewController") ?? dummy
        return [first, second, third, last]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1

        if previousIndex < 0  {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        if nextIndex >= pages.count {
            return nil
        }
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
