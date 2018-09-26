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
                //user로 로그인한 사용자 정보 접근
                guard let user = user else { return }
                guard let id = user.id else { return }
                //클라이언트에 유저 정보 저장
                User.add(id: id, nickname: "")
                //키체인에 id 저장. 지금은 UserDefaults로 진행
                UserDefaults.standard.set(id, forKey: "id")
                guard let next = UIViewController.instantiate(storyboard: "Tutorial", identifier: TutorialViewController.classNameToString) else { return }
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
