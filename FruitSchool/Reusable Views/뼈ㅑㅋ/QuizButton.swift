//
//  QuizButton.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

@IBDesignable
class QuizButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        setTitleColor(.black, for: [])
        layer.cornerRadius = cornerRadius
        backgroundColor = .white
    }
}
