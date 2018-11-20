//
//  CertificateViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit
import SVProgressHUD

class CertificateViewController: UIViewController {

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
    
    var nickname: String {
        return nicknameTextField.text ?? ""
    }
    
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = dateFormatter.string(from: Date())
        }
    }
    
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(touchUpStartButton(_:)), for: .touchUpInside)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    @objc func touchUpStartButton(_ sender: UIButton) {
        if nickname.isEmpty {
            UIAlertController
                .alert(title: "", message: "닉네임을 입력하세요.")
                .action(title: "확인")
                .present(to: self)
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController") else { return }
        SVProgressHUD.show()
        API.requestFruitList { response, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    UIAlertController.presentErrorAlert(to: next, error: error.localizedDescription)
                }
                return
            }
            guard let response = response else { return }
            for data in response.data {
                ChapterRecord.add(id: data.id, title: data.title, english: data.english, grade: data.grade)
            }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                UserRecord.add(nickname: self.nickname)
                self.present(next, animated: true)
            }
        }
    }
}

extension CertificateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
