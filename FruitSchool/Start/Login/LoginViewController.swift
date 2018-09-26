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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "TUTORIAL") == false {
            guard let viewController = UIViewController.instantiate(storyboard: "Tutorial", identifier: "TutorialViewController") else { return }
            self.present(viewController, animated: false)
            return
        }
    }
    
    @objc func didTouchUpLoginButton(_ sender: UIButton) {
        guard let session = KOSession.shared() else { return }
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open { [weak self] error in
            if let error = error {
                self?.presentErrorAlert(error.localizedDescription)
                return
            }
            KOSessionTask.userMeTask(completion: { [weak self] (error, user) in
                if let error = error {
                    self?.presentErrorAlert(error.localizedDescription)
                    return
                }
                guard let user = user else { return }
                //user로 로그인한 사용자 정보 접근하기
                //user.id 말고 쓸만한 거 없음
                //튜토리얼로 이동하기
                guard let next = UIViewController.instantiate(storyboard: "Tutorial", identifier: "TutorialViewController") else { return }
                next.modalTransitionStyle = .flipHorizontal
                self?.present(next, animated: true, completion: nil)
            })
        }
    }
}

extension LoginViewController {
    private func presentErrorAlert(_ message: String) {
        UIAlertController
            .alert(title: "", message: message)
            .action(title: "OK")
            .present(to: self)
    }
}
