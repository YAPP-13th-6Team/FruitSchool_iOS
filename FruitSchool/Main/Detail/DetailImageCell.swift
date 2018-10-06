//
//  DetailImageCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailImageCell: UITableViewCell {

    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var fruitTitleLabel: UILabel!
    @IBOutlet weak var fruitGradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
    }
    
    func setProperties(_ object: FruitResponse.Data?) {
        guard let object = object else { return }
        fruitImageView.image = nil
        fruitTitleLabel.text = object.title
        fruitGradeLabel.text = Grade(rawValue: object.grade)?.expression
    }
}
