//
//  GuideBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class GuideBookCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .gray
        let path = UIBezierPath(roundedRect: imageView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 0))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        imageView.layer.mask = shapeLayer
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
}

extension GuideBookCell {
    private func setProperties() {
        
    }
}
