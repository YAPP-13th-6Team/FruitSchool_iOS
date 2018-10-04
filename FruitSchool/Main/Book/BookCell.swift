//
//  FruitBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        alpha = 1
    }
    
    func setProperties(at grade: Int) {
        let myGrade = UserDefaults.standard.integer(forKey: "grade")
        if myGrade < grade {
            alpha = 0.7
        }
    }
}
