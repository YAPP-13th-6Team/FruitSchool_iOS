//
//  DetailImageCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

protocol DetailImageCellDelegate: class {
    func didTouchUpBackButton(_ sender: UIButton)
}

class DetailImageCell: UITableViewCell {

    weak var delegate: DetailImageCellDelegate?
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var fruitTitleLabel: UILabel!
    @IBOutlet weak var fruitGradeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
        backButton.addTarget(self, action: #selector(touchUpBackButton(_:)), for: .touchUpInside)
    }
    
    @objc func touchUpBackButton(_ sender: UIButton) {
        delegate?.didTouchUpBackButton(sender)
    }
    
    func setProperties(_ object: FruitResponse) {
        fruitImageView.image = nil
        fruitTitleLabel.text = object.title
        fruitGradeLabel.text = Grade(rawValue: object.grade)?.expression
    }
}
