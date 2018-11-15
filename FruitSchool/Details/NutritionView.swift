//
//  NutritionView.swift
//  FruitSchool
//
//  Created by Kim DongHwan on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class NutritionView: UIView {
    
    init(frame: CGRect, object: NutritionTip) {
        super.init(frame: frame)
        print(object)
        drawNutrition(object: object)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawNutrition(object: NutritionTip) {
        
        let sodiumValue: Double = {
            if object.sodium >= 10 {
                return 100
            } else {
                return object.sodium / 10 * 100
            }
        }()
        
        let proteinValue: Double = {
            if object.protein >= 1 {
                return 100
            } else {
                return object.protein * 100
            }
        }()
        
        let sugarValue: Double = {
            if object.sugar >= 20 {
                return 100
            } else {
                return object.sugar / 20 * 100
            }
        }()
        
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: (width + width/2)/3, y: (height*2/3) * (100-CGFloat(sodiumValue)) / 100))
        path.addLine(to: CGPoint(x: ((width + width/2)/3) * (100-CGFloat(proteinValue)) / 100, y: (height*2/3) + ((height*2/3)/2) * CGFloat(proteinValue) / 100))
        path.addLine(to: CGPoint(x: ((width + width/2)/3) * (100+CGFloat(sugarValue)) / 100, y: (height*2/3) + ((height*2/3)/2) * CGFloat(sugarValue) / 100))
        path.close()
        
        print(sodiumValue)
        print(proteinValue)
        print(sugarValue)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.4549019608, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        shapeLayer.strokeColor = #colorLiteral(red: 0.4549019608, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        shapeLayer.lineWidth = 1.0
        
        self.alpha = 0.0
        self.layer.addSublayer(shapeLayer)
    }
}
