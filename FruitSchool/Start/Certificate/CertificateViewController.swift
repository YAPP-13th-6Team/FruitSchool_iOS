//
//  CertificateViewController.swift
//  FruitSchool
//
//  Created by Presto on 29/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class CertificateViewController: UIViewController {

    var id: String = ""
    var nickname: String {
        return nicknameTextField.text ?? ""
    }
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter
    }()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        contentView.layer.cornerRadius = 10
        startButton.layer.cornerRadius = startButton.bounds.height / 2
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.main.cgColor
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
        UserDefaults.standard.set(id, forKey: "id")
        UserRecord.add(nickname: nickname)
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
                ChapterRecord.add(id: data.id, title: data.title, grade: data.grade)
            }
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
