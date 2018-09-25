//
//  PromotionReviewCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 22..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class PromotionReviewCell: UITableViewCell {

    var quizView: QuizView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quizView = UIView.instantiateFromXib(xibName: "QuizView") as? QuizView
        quizView.delegate = self
        self.addSubview(quizView)
        quizView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            quizView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            quizView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            quizView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            quizView.heightAnchor.constraint(equalToConstant: self.frame.width)
            ])
    }
    
    func setProperties() {
        
    }
}

extension PromotionReviewCell: QuizViewDelegate {
    var title: String {
        return ""
    }
    
    var answers: [String] {
        return [String]()
    }
    
    var number: Int {
        return 1
    }
    
    var answerIndex: Int {
        return 0
    }
    
    func didTouchUpQuizButtons(_ sender: UIButton) {
        
    }
}
