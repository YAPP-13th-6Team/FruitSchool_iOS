//
//  UnlockView.swift
//  FruitSchool
//
//  Created by Presto on 30/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

protocol UnlockViewDelegate: class {
    var description: String { get }
    var fruitImage: UIImage { get }
    var fruitTitle: String { get }
    func didTouchUpConfirmButton(_ sender: UIButton)
}

class UnlockView: UIView {

    weak var delegate: UnlockViewDelegate?
    @IBOutlet weak var stackView: UIStackView!
    var fruitImageView: UIImageView! {
        return stackView.arrangedSubviews.first as? UIImageView
    }
    var fruitTitleLabel: UILabel! {
        return stackView.arrangedSubviews.last as? UILabel
    }
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.text = delegate?.description
        fruitImageView.image = delegate?.fruitImage
        fruitTitleLabel.text = delegate?.fruitTitle
        confirmButton.addTarget(self, action: #selector(didTouchUpConfirmButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTouchUpConfirmButton(_ sender: UIButton) {
        delegate?.didTouchUpConfirmButton(sender)
    }
}
