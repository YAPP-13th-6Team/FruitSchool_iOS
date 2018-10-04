//
//  DetailQuizCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailQuizCell: UITableViewCell {

    var quizView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quizView = UIView.instantiateFromXib(xibName: "QuizView")
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
    
    func setProperties(_ object: [QuizResponse]?) {
        guard let object = object else { return }
        
    }
}
