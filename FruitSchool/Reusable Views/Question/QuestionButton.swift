//
//  QuizButton.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

@IBDesignable
class QuestionButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setup()
//    }
//    
    func setup() {
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        setTitleColor(.black, for: [])
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .light)
        backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    }
}
