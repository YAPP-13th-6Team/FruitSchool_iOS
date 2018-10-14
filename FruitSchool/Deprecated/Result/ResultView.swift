//
//  ResultView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 26..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var handler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.addTarget(self, action: #selector(didTouchUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpButton(_ sender: UIButton) {
        handler?()
    }
}
