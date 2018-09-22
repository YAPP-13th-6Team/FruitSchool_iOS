//
//  DetailHealthCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class DetailIntakeTipCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProperties(_ object: IntakeTip) {
        let text: String = "\(object.intakeMethodText)\(object.chemistryText)\(object.precautionText)\(object.dietText)\(object.effectText)"
        textLabel?.text = text
    }
}
