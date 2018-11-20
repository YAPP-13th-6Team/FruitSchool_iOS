//
//  DetailTitleAndContentCell.swift
//  FruitSchool
//
//  Created by Presto on 15/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class DetailStandardTipCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    func setProperties(_ object: FruitResponse.Data?, for indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 1:
            titleLabel.text = "제철"
            contentLabel.text = object?.season
        case 2:
            guard let tip = object?.standardTip.tips[row] else { return }
            titleLabel.text = tip.title
            contentLabel.text = tip.content
        default:
            break
        }
    }
}
