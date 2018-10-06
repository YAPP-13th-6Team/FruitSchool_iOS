//
//  PromotionReviewCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class PromotionReviewCell: UICollectionViewCell {

    var quizView: QuizView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuizView
        self.addSubview(quizView)
        quizView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quizView.topAnchor.constraint(equalTo: topAnchor),
            quizView.trailingAnchor.constraint(equalTo: trailingAnchor),
            quizView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for index in 0..<4 {
            quizView[index].isSelected = false
        }
        quizView.imageView.image = nil
        quizView.numberLabel.text = nil
        quizView.titleLabel.text = nil
        quizView[0].setTitle(nil, for: [])
        quizView[1].setTitle(nil, for: [])
        quizView[2].setTitle(nil, for: [])
        quizView[3].setTitle(nil, for: [])
    }
}
