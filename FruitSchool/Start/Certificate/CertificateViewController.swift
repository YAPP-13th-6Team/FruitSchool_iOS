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
    var nickname: String = ""
    lazy var certificateView: UIView = {
        let dummy = UIView()
        guard let certificateView = UIView.instantiateFromXib(xibName: "CertificateView") as? CertificateView else { return dummy }
        certificateView.delegate = self
        return certificateView
    }()
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        certificateView.layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        contentView.layer.cornerRadius = 10
        contentView.addSubview(certificateView)
        certificateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            certificateView.topAnchor.constraint(equalTo: contentView.topAnchor),
            certificateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            certificateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            certificateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

extension CertificateViewController: CertificateViewDelegate {
    var certificateNickname: String {
        return nickname
    }
    
    func didTouchUpButton(_ sender: UIButton) {
        UserDefaults.standard.set(id, forKey: "id")
        UserRecord.add(nickname: nickname)
        //guard let next = UIViewController.instantiate(storyboard: "Main", identifier: MainTabBarController.classNameToString) else { return }
        guard let next = UIViewController.instantiate(storyboard: "Book", identifier: "BookNavigationController") else { return }
        next.modalTransitionStyle = .crossDissolve
        IndicatorView.shared.showIndicator(message: "Loading...")
        API.requestFruitList { response, statusCode, error in
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
