//
//  DetailImageCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import Kingfisher

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
        guard let url = URL(string: API.imageBaseURL + object.english.toImageName(grade: object.grade, isDetail: true)) else { return }
        fruitImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { image, _, _, _ in
            if image == nil {
                self.fruitImageView.contentMode = .scaleAspectFit
                self.fruitImageView.image = UIImage(named: "boss_clear") ?? UIImage()
            }
        }
        fruitNameLabel.text = object.title
        englishLabel.text = object.english
        nthCardLabel.text = index.toOrdinalExpression
        gradeLabel.text = Grade(rawValue: object.grade)?.expression
    }
}
