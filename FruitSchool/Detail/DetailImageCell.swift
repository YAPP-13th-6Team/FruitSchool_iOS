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
    
    @IBOutlet weak var gradeLabel: UILabel! {
        didSet {
            gradeLabel.backgroundColor = .white
            gradeLabel.layer.cornerRadius = gradeLabel.bounds.height / 2
            gradeLabel.clipsToBounds = true
        }
    }

    func setProperties(_ object: FruitResponse.Data?, at index: Int) {
        guard let object = object else { return }
        fruitImageView.image = UIImage(named: object.english.toImageName(grade: object.grade, isDetail: true)) ?? UIImage(named: "detail_sample_image")
        fruitNameLabel.text = object.title
        englishLabel.text = object.english
        nthCardLabel.text = index.toOrdinalExpression
        gradeLabel.text = Grade(rawValue: object.grade)?.expression
    }
}
