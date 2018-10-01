//
//  CertificateView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol CertificateViewDelegate: class {
    func didTouchUpButton(_ sender: UIButton)
}

class CertificateView: UIView {
    
    weak var delegate: CertificateViewDelegate?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(didTouchUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpButton(_ sender: UIButton) {
        delegate?.didTouchUpButton(sender)
    }
}
