//
//  ExerciseCell.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    var quizView: QuizView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuizView
        addSubview(quizView)
        quizView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizView.topAnchor.constraint(equalTo: topAnchor),
            quizView.leadingAnchor.constraint(equalTo: leadingAnchor),
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
