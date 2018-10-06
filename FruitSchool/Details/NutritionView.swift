//
//  NutritionView.swift
//  FruitSchool
//
//  Created by Kim DongHwan on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class NutritionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawNutrition()
    }
    
    func drawNutrition() {
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        
        // 일단 보여주기 용으로 0 ~ 100 사이 랜덤값 적용
        let sodiumValue: CGFloat  = {
            return CGFloat.random(in: 0...100)
        }()
        
        let proteinValue: CGFloat = {
            return CGFloat.random(in: 0...100)
        }()
        
        let sugarValue: CGFloat = {
            return CGFloat.random(in: 0...100)
        }()
        
        let path = UIBezierPath()
        // 나트륨
        path.move(to: CGPoint(x: (width + width/2)/3, y: (height*2/3) * (100-sodiumValue) / 100))
        // 단백질
        path.addLine(to: CGPoint(x: ((width + width/2)/3) * (100-proteinValue) / 100, y: (height*2/3) + ((height*2/3)/2) * proteinValue / 100))
        // 당질
        path.addLine(to: CGPoint(x: ((width + width/2)/3) * (100+sugarValue) / 100, y: (height*2/3) + ((height*2/3)/2) * sugarValue / 100))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.darkGray.cgColor
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.lineWidth = 1.0
        
        self.alpha = 0.0
        self.layer.addSublayer(shapeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
