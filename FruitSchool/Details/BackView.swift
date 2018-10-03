//
//  NutritionTipView.swift
//  FruitSchool
//
//  Created by Kim DongHwan on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class BackView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawBackground()
    }
    
    func drawBackground() {
        let width: CGFloat = self.frame.size.width
        let height: CGFloat = self.frame.size.height
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: width/2, y: 0.0))
        path1.addLine(to: CGPoint(x: 0.0, y: height))
        path1.addLine(to: CGPoint(x: width, y: height))
        path1.close()
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: width/2, y: height * 2.5 / 15))
        path2.addLine(to: CGPoint(x: CGFloat(Double(width) * 3.0.squareRoot() * 1.1 / 15), y: height * 13.7 / 15))
        path2.addLine(to: CGPoint(x: width - CGFloat(Double(width) * 3.0.squareRoot() * 1.1 / 15), y: height * 13.7 / 15))
        path2.close()
        
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: width/2, y: height * 5 / 15))
        path3.addLine(to: CGPoint(x: CGFloat(Double(width) * 3.0.squareRoot() * 2.2 / 15), y: height * 12.4 / 15))
        path3.addLine(to: CGPoint(x: width - CGFloat(Double(width) * 3.0.squareRoot() * 2.2 / 15), y: height * 12.4 / 15))
        path3.close()
        
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: width/2, y: height * 7.5 / 15))
        path4.addLine(to: CGPoint(x: CGFloat(Double(width) * 3.0.squareRoot() * 3.2 / 15), y: height * 11.3 / 15))
        path4.addLine(to: CGPoint(x: width - CGFloat(Double(width) * 3.0.squareRoot() * 3.2 / 15), y: height * 11.3 / 15))
        path4.close()
    
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.fillColor = UIColor.white.cgColor
        shapeLayer1.strokeColor = UIColor.lightGray.cgColor
        shapeLayer1.lineWidth = 3.0
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = path2.cgPath
        shapeLayer2.fillColor = UIColor.white.cgColor
        shapeLayer2.strokeColor = UIColor.lightGray.cgColor
        shapeLayer2.lineWidth = 3.0
        
        let shapeLayer3 = CAShapeLayer()
        shapeLayer3.path = path3.cgPath
        shapeLayer3.fillColor = UIColor.white.cgColor
        shapeLayer3.strokeColor = UIColor.lightGray.cgColor
        shapeLayer3.lineWidth = 3.0
        
        let shapeLayer4 = CAShapeLayer()
        shapeLayer4.path = path4.cgPath
        shapeLayer4.fillColor = UIColor.white.cgColor
        shapeLayer4.strokeColor = UIColor.lightGray.cgColor
        shapeLayer4.lineWidth = 3.0
        
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        self.layer.addSublayer(shapeLayer3)
        self.layer.addSublayer(shapeLayer4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
