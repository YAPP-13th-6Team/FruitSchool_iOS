//
//  NicknameInputViewController.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 27..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class NicknameInputViewController: UIViewController {

    var id: String = ""
    var nickname: String {
        return textField.text ?? ""
    }
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.addTarget(self, action: #selector(didTouchUpButton(_:)), for: .touchUpInside)
        textField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCreatingUser(_:)), name: .didReceiveCreatingUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorReceiveCreatingUser(_:)), name: .errorReceiveCreatingUser, object: nil)
    }
    
    @objc func didReceiveCreatingUser(_ notification: Notification) {
        //클라이언트에 유저 정보 저장
        User.add(id: id, nickname: nickname)
        //키체인에 id 저장. 지금은 UserDefaults로 진행
        UserDefaults.standard.set(id, forKey: "id")
        guard let next = UIViewController.instantiate(storyboard: "Tutorial", identifier: TutorialViewController.classNameToString) else { return }
        next.modalTransitionStyle = .flipHorizontal
        DispatchQueue.main.async { [weak self] in
            self?.present(next, animated: true, completion: nil)
        }
    }
    
    @objc func errorReceiveCreatingUser(_ notification: Notification) {
        UIAlertController.presentErrorAlert(to: self, error: "Error")
    }
    
    @objc func didTouchUpButton(_ sender: UIButton) {
        if nickname.isEmpty { return }
        API.requestCreatingUser(id: id, nickname: nickname)
    }
}

extension NicknameInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
