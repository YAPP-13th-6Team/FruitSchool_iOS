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
        //튜토리얼 모달로 띄워줌
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
                //user로 로그인한 사용자 정보 접근
                guard let user = user else { return }
                guard let id = user.id else { return }
                let nickname = user.nickname ?? "익명의사용자"
                /**
                 중복 사용자 검증.
                 중복되었다면 id, nickname, grade를 UserDefaults에 저장하고 Main으로 이동 (id는 추후 키체인에 저장)
                 중복되지 않았다면 CertificateViewController로 이동하여 사용자 등록 절차 진행
                 */
                API.requestCheckingDuplicatedUser(id: id, completion: { (isDuplicated, error) in
                    if let error = error {
                        UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                        return
                    }
                    guard let isDuplicated = isDuplicated else { return }
                    if isDuplicated {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(id, forKey: "id")
                        userDefaults.set(nickname, forKey: "nickname")
                        userDefaults.set(0, forKey: "grade")
                        guard let next = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString) else { return }
                        next.modalTransitionStyle = .flipHorizontal
                        DispatchQueue.main.async { [weak self] in
                            self?.present(next, animated: true, completion: nil)
                        }
                    } else {
                        API.requestCreatingUser(id: id, nickname: nickname, completion: { (statusCode, error) in
                            if let error = error {
                                UIAlertController.presentErrorAlert(to: self, error: error.localizedDescription)
                                return
                            }
                            guard let next = UIViewController.instantiate(storyboard: "Certificate", identifier: CertificateViewController.classNameToString) as? CertificateViewController else { return }
                            next.id = id
                            next.nickname = nickname
                            next.modalTransitionStyle = .crossDissolve
                            DispatchQueue.main.async { [weak self] in
                                self?.present(next, animated: true, completion: nil)
                            }
                            //상태 코드에 따라 분기. 성공했을 때만 다음으로 넘어가기. 지금은 에러만 안나면 성공으로 간주함.
                        })
                    }
                })
            })
        }
    }
}
