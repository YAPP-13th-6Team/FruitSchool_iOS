//
//  ResultView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 26..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol ResultViewDelegate: class {
    var title: String { get }
    var description: String { get }
    func didTouchUpButton(_ sender: UIButton)
}

class ResultView: UIView {
    
    weak var delegate: ResultViewDelegate? {
        didSet {
            titleLabel.text = delegate?.title
            descriptionLabel.text = delegate?.description
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        button.addTarget(self, action: #selector(didTouchUpButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpButton(_ sender: UIButton) {
        delegate?.didTouchUpButton(sender)
    }
}
