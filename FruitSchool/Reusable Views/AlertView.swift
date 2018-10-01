//
//  AlertView.swift
//  FruitSchool
//
//  Created by Presto on 01/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

protocol AlertViewDelegate: class {
    var title: String { get set }
    var message: String { get set }
    var positiveButtonTitle: String { get set }
    var negativeButtonTitle: String { get set }
    func didTouchUpPositiveButton(_ sender: UIButton)
    func didTouchUpNegativeButton(_ sender: UIButton)
}

class AlertView: UIView {

    weak var delegate: AlertViewDelegate?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        titleLabel.text = delegate?.title
        messageLabel.text = delegate?.message
        positiveButton.setTitle(delegate?.positiveButtonTitle, for: [])
        negativeButton.setTitle(delegate?.negativeButtonTitle, for: [])
        positiveButton.addTarget(self, action: #selector(didTouchUpPositiveButton(_:)), for: .touchUpInside)
        negativeButton.addTarget(self, action: #selector(didTouchUpNegativeButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpPositiveButton(_ sender: UIButton) {
        delegate?.didTouchUpPositiveButton(sender)
    }
    
    @objc func didTouchUpNegativeButton(_ sender: UIButton) {
        delegate?.didTouchUpNegativeButton(sender)
    }
}
