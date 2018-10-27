//
//  TutorialViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//
// Tutorial 화면을 위한 donald 브랜치 생성

import UIKit

class TutorialViewController: UIViewController {

    lazy var pages: [UIViewController] = {
        let dummy = UIViewController()
        let first = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial1ViewController") ?? dummy
        let second = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial2ViewController") ?? dummy
        let third = UIViewController.instantiate(storyboard: "Tutorial", identifier: "Tutorial3ViewController") ?? dummy
        return [first, second, third]
    }()
    @IBOutlet weak var pageControl: UIPageControl!
    var pageContainer: UIPageViewController!
    var currentIndex: Int?
    var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        if let firstViewController = pages.first {
            pageContainer.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        view.addSubview(pageContainer.view)
        view.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        // 마지막 페이지의 시작하기 버튼에 액션 달아놓기
        (pages.last?.view.viewWithTag(100) as? UIButton)?.addTarget(self, action: #selector(didTouchUpStartButton(_:)), for: .touchUpInside)
        
    }
    
    @objc func didTouchUpStartButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString) else { return }
        present(next, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else { return nil }
        if currentIndex == 0 { return nil }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
//        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
//        let previousIndex = viewControllerIndex - 1
//
//        if previousIndex < 0 {
//            return nil
//        }
//        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController) else { return nil }
        if currentIndex == pages.count - 1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
//        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
//        let nextIndex = viewControllerIndex + 1
//
//        if nextIndex >= pages.count {
//            return nil
//        }
//        return pages[nextIndex]
    }
}

extension TutorialViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let first = pendingViewControllers.first else { return }
        pendingIndex = pages.index(of: first)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
}
