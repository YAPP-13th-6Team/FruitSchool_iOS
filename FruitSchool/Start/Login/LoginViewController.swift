//
//  LoginViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import KakaoOpenSDK

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: KOLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTouchUpLoginButton(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveDuplicatedUser(_:)), name: .didReceiveDuplicatedUser, object: nil)
    }
}
// MARK: - Notification Handler
extension LoginViewController {
    @objc func didReceiveDuplicatedUser(_ notification: Notification) {
        guard let isDuplicated = notification.userInfo?["isDuplicated"] as? Bool else { return }
        if isDuplicated {
            guard let next = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString) else { return }
            next.modalTransitionStyle = .flipHorizontal
            DispatchQueue.main.async { [weak self] in
                self?.present(next, animated: true, completion: nil)
            }
        } else {
            guard let id = notification.userInfo?["id"] as? String else { return }
            guard let next = UIViewController.instantiate(storyboard: "Login", identifier: NicknameInputViewController.classNameToString) as? NicknameInputViewController else { return }
            next.id = id
            next.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async { [weak self] in
                self?.present(next, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Button Touch Event
extension LoginViewController {
    @objc func didTouchUpLoginButton(_ sender: UIButton) {
        guard let session = KOSession.shared() else { return }
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open { [weak self] error in
            if let error = error {
                UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                return
            }
            KOSessionTask.userMeTask(completion: { [weak self] (error, user) in
                if let error = error {
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                    return
                }
                //user로 로그인한 사용자 정보 접근
                guard let user = user else { return }
                guard let id = user.id else { return }
                //중복 사용자 검증. 중복되면 Main으로 이동. 중복되지 않으면 NicknameInput으로 이동하여 사용자 등록 절차 진행.
                API.requestCheckingDuplicatedUser(id: id)
            })
        }
    }
}
