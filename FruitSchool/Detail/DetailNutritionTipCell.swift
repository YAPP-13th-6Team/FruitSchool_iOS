//
//  DetailTriangleCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailNutritionTipCell: UITableViewCell {

    @IBOutlet weak var nutritionTipView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProperties(_ object: NutritionTip?) {
        guard let object = object else { return }
        
        let width: CGFloat = nutritionTipView.frame.width
        let height: CGFloat = CGFloat(Double(width) * 3.0.squareRoot() / 2)
        
        let backView = BackView(frame: CGRect(x: 0, y: 10.0, width: width, height: height))
        nutritionTipView.addSubview(backView)
        
        let nutritionView = NutritionView(frame: CGRect(x: 0, y: 10.0, width: width, height: height), object: object)
        nutritionTipView.addSubview(nutritionView)
        
        UIView.animate(withDuration: 1) {
            nutritionView.alpha = 0.7
        }
    }
}
