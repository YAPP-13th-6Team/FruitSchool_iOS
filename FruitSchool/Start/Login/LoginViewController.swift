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
                print(session.token.accessToken)
                API.requestAuthorization(token: session.token.accessToken, completion: { response, statusCode, error in
                    if let error = error {
                        print(error.localizedDescription)
                        DispatchQueue.main.async { [weak self] in
                            UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                            return
                        }
                    }
                    guard let response = response else { return }
                    // 서버에서 토큰 내려오면 키체인에 저장. 개발 단계에서는 UserDefaults에 저장.
                    print(response.data.authorization)
                    UserDefaults.standard.set(response.data.authorization, forKey: "authorization")
                    guard let next = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString) as? CertificateViewController else { return }
                    next.id = user?.id ?? ""
                    next.nickname = user?.nickname ?? "익명의사용자"
                    next.modalTransitionStyle = .flipHorizontal
                    DispatchQueue.main.async { [weak self] in
                        self?.present(next, animated: true, completion: nil)
                    }
                })
            })
        }
    }
}
