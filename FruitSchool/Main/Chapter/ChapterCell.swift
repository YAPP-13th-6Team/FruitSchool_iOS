//
//  GuideBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class ChapterCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .gray
        nameLabel.backgroundColor = .lightGray
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        alpha = 1
    }
    
    func setProperties(_ object: FruitResponse) {
        let myGrade = UserDefaults.standard.integer(forKey: "grdae")
        if myGrade < object.grade {
            alpha = 0.5
            isUserInteractionEnabled = false
        }
        nameLabel.text = object.title
    }
}
