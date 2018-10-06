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
    
    var presentsTutorial: Bool = false
    @IBOutlet weak var loginButton: KOLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTouchUpLoginButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !presentsTutorial {
            guard let tutorialViewController = UIViewController.instantiate(storyboard: "Tutorial", identifier: TutorialViewController.classNameToString) else { return }
            self.present(tutorialViewController, animated: true) { [weak self] in
                self?.presentsTutorial = true
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
                print(session.token)
                guard let user = user else { return }
                guard let id = user.id else { return }
                let nickname = user.nickname ?? "익명의사용자"
                // 중복 사용자 검증.
                // 사용자가 이미 서비스에 가입한 상태라면 nickname, grade를 UserDefaults에 저장하고 Main으로 이동
                // 사용자가 서비스를 처음 사용한다면 CertificateViewController로 이동하여 사용자 등록 절차 진행
                guard let next = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString) as? CertificateViewController else { return }
                next.id = id
                next.nickname = nickname
                next.modalTransitionStyle = .flipHorizontal
                DispatchQueue.main.async { [weak self] in
                    self?.present(next, animated: true, completion: nil)
                }
            })
        }
    }
}
