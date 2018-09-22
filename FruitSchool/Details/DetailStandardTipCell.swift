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
    
    func setProperties(_ object: StandardTip) {
        let text: String = "\(object.purchasingTipText)\(object.storageTemperatureText)\(object.storageDateText)\(object.storageMethodText)\(object.careMethodText)"
        textLabel?.text = text
    }
}
