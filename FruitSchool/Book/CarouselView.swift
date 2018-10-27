//
//  CarouselView.swift
//  FruitSchool
//
//  Created by Kim DongHwan on 27/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class CarouselView: UICollectionView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func transformScale(cell: UICollectionViewCell) {
        let cellCenter: CGPoint = self.convert(cell.center, to: nil)
        let screenCenterX: CGFloat = UIScreen.main.bounds.width / 2
        let reductionRation: CGFloat = -0.0009
        let maxScale: CGFloat = 1
        let cellCenterDisX: CGFloat = abs(screenCenterX - cellCenter.x)
        let newScale = reductionRation * cellCenterDisX + maxScale
        cell.transform = CGAffineTransform(scaleX: newScale, y: newScale)
    }
    
    func scrollToFirstItem() {
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cells = self.visibleCells
        
        for cell in cells {
            transformScale(cell: cell)
        }
    }
}
