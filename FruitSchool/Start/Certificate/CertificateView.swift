//
//  CertificateView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol CertificateViewDelegate: class {
    var certificateNickname: String { get }
    func didTouchUpButton(_ sender: UIButton)
}

class CertificateView: UIView {
    
    weak var delegate: CertificateViewDelegate? {
        didSet {
            nicknameLabel.text = delegate?.certificateNickname
        }
    }
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd"
        return dateFormatter
    }()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 10
        dateLabel.text = dateFormatter.string(from: Date())
        startButton.addTarget(self, action: #selector(didTouchUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpButton(_ sender: UIButton) {
        delegate?.didTouchUpButton(sender)
    }
}
