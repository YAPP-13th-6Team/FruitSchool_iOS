//
//  DetailTriangleCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailNutritionTipCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let height = backView.frame.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.center.x, y: 0))
        path.addLine(to: CGPoint(x: self.center.x - height / 2, y: height))
        path.addLine(to: CGPoint(x: self.center.x + height / 2, y: height))
        path.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 5
        self.layer.addSublayer(shapeLayer)
    }
    
    func setProperties(_ object: NutritionTip) {
        
    }
}
