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
    @IBOutlet weak var nthCardLabel: UILabel!
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .gray
        fruitImageView.image = UIImage(named: "detail_sample_image")
        gradeLabel.backgroundColor = .white
        gradeLabel.layer.cornerRadius = gradeLabel.bounds.height / 2
        gradeLabel.clipsToBounds = true
    }
    
    func setProperties(_ object: FruitResponse.Data?, at index: Int) {
        guard let object = object else { return }
        fruitImageView.image = nil
        fruitNameLabel.text = object.title
        englishLabel.text = object.english
        nthCardLabel.text = (index + 1).toOrdinalExpression
        gradeLabel.text = Grade(rawValue: object.grade)?.expression
    }
}
