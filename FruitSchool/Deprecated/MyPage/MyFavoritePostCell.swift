//
//  MyFavoritePostCell.swift
//  FruitSchool
//
//  Created by 이재은 on 05/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class MyFavoritePostCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setProperties() {
        textLabel?.text = "좋아요"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
