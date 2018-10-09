//
//  QuizButton.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 19..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class QuizButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
        setTitleColor(.black, for: [])
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .light)
        backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    }
}
