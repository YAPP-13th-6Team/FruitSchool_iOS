//
//  LoginViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    var user: KOUserMe?
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
                guard let `self` = self else { return }
                self.user = user
                if let error = error {
                    UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                    return
                }
                API.requestAuthorization(token: session.token.accessToken, completion: self.didReceiveAuthorization)
            })
        }
    }
}
// MARK: - API Response Completion Handler
private extension LoginViewController {
    // 올바른 응답이 오면 authorization을 키체인에 저장하고 입학증서 화면으로 넘어가 앱 시작을 준비함
    func didReceiveAuthorization(response: LoginResponse?, statusCode: Int?, error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                return
            }
        }
        guard let response = response else { return }
        KeychainWrapper.standard.set(response.data.authorization, forKey: "authorization")
        guard let next = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString) as? CertificateViewController else { return }
        next.id = user?.id ?? ""
        next.nickname = user?.nickname ?? "익명의사용자"
        DispatchQueue.main.async { [weak self] in
            self?.present(next, animated: true, completion: nil)
        }
    }
}
