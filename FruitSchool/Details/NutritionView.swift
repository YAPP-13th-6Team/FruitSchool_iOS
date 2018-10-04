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
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: (width + width/2)/3, y: height*2/3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
