//
//  Tutorial4ViewController.swift
//  UIPageViewControllerTest2
//
//  Created by Kim DongHwan on 2018. 9. 23..
//  Copyright © 2018년 Kim DongHwan. All rights reserved.
//

import UIKit

class Tutorial4ViewController: UIViewController {

    lazy var certificateView: UIView = {
        let dummy = UIView()
        guard let certificateView = UIView.instantiateFromXib(xibName: "CertificateView") as? CertificateView else { return dummy }
        certificateView.delegate = self
        return certificateView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificateView.layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(certificateView)
    }
}

extension Tutorial4ViewController: CertificateViewDelegate {
    func didTouchUpButton(_ sender: UIButton) {
        guard let next = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString) else { return }
        next.modalTransitionStyle = .flipHorizontal
        self.present(next, animated: true) {
            UserDefaults.standard.set(true, forKey: "checksTutorial")
            UserDefaults.standard.synchronize()
        }
    }
}
