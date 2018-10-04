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
        quizView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(quizView)
        NSLayoutConstraint.activate([
            quizView.topAnchor.constraint(equalTo: topAnchor),
            quizView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quizView.trailingAnchor.constraint(equalTo: trailingAnchor),
            quizView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quizView = nil
    }
    
    func setProperties(_ object: QuizResponse?, at item: Int) {
        guard let object = object else { return }
        quizView.setProperties(object, at: item)
    }
}
