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

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter
    }()
    
    private var nickname: String {
        return nicknameTextField.text ?? ""
    }
    
    @IBOutlet private weak var backgroundView: UIView! {
        didSet {
            backgroundView.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet private weak var nicknameTextField: UITextField!
    
    @IBOutlet private weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = dateFormatter.string(from: Date())
        }
    }
    
    @IBOutlet private weak var startButton: UIButton! {
        didSet {
            startButton.addTarget(self, action: #selector(touchUpStartButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var dummyView: UIView! {
        didSet {
            dummyView.layer.cornerRadius = 13
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if deviceModel == .iPad {
            NSLayoutConstraint.activate([
                dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                dummyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dummyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.63),
                dummyView.widthAnchor.constraint(equalTo: dummyView.heightAnchor, multiplier: 270 / 422)
                ])
        } else {
            NSLayoutConstraint.activate([
                dummyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                dummyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                dummyView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.63),
                dummyView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 270 / 422)
                ])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }

    @objc private func touchUpStartButton(_ sender: UIButton) {
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
