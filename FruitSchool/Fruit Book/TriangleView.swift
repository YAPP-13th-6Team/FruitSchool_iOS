//
//  TriangleView.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.beginPath()
        context.move(to: CGPoint(x: rect.maxX / 2, y: rect.minY + 20))
        context.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY - 50))
        context.addLine(to: CGPoint(x: rect.maxX - 50, y: rect.maxY - 20))
        context.closePath()
        context.setFillColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        context.fillPath()
    }
}
