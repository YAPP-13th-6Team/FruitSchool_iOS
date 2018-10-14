//
//  AlertView.swift
//  FruitSchool
//
//  Created by Presto on 01/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    var positiveHandler: (() -> Void)?
    var negativeHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        positiveButton.addTarget(self, action: #selector(didTouchUpPositiveButton(_:)), for: .touchUpInside)
        negativeButton.addTarget(self, action: #selector(didTouchUpNegativeButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpPositiveButton(_ sender: UIButton) {
        removeFromSuperview()
        positiveHandler?()
    }

    @objc func didTouchUpNegativeButton(_ sender: UIButton) {
        removeFromSuperview()
        negativeHandler?()
    }
}
