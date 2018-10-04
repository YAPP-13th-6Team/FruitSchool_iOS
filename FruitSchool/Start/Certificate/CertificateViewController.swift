//
//  CertificateViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class CertificateViewController: UIViewController {

    var id: String = ""
    var nickname: String = ""
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

extension CertificateViewController: CertificateViewDelegate {
    var certificateNickname: String {
        return nickname
    }
    
    func didTouchUpButton(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(id, forKey: "id")
        userDefaults.set(nickname, forKey: "nickname")
        userDefaults.set(0, forKey: "grade")
        guard let next = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString) else { return }
        next.modalTransitionStyle = .flipHorizontal
        self.present(next, animated: true)
    }
}
