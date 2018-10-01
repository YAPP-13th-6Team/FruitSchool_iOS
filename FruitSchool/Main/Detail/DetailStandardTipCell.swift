//
//  DetailBasicInfoCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailStandardTipCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProperties(_ object: StandardTip, at row: Int) {
        let tip = object.tips[row]
        textLabel?.text = tip.title
        detailTextLabel?.text = tip.content
    }
}