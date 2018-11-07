//
//  CertificateViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        backgroundView.layer.cornerRadius = 13
        dateLabel.text = dateFormatter.string(from: Date())
        startButton.addTarget(self, action: #selector(startButtonDidTouchUp(_:)), for: .touchUpInside)
    }
    
    @objc func startButtonDidTouchUp(_ sender: UIButton) {
        if nicknameTextField.text?.isEmpty ?? true {
            UIAlertController
                .alert(title: "", message: "닉네임을 입력하세요.")
                .action(title: "확인")
                .present(to: self)
            return
        }
        guard let next = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController") else { return }
        IndicatorView.shared.showIndicator()
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
            UserRecord.add(nickname: self.nickname)
            IndicatorView.shared.hideIndicator()
            DispatchQueue.main.async { [weak self] in
                self?.present(next, animated: true)
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
