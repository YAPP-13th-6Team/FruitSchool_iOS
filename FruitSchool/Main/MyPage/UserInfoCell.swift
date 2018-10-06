//
//  UserInfoCell.swift
//  FruitSchool
//
//  Created by 이재은 on 05/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var userRankingLabel: UILabel!
    @IBOutlet weak var finishedFruitsLabel: UILabel!
    @IBOutlet weak var editNickNameButton: UIButton!
    @IBOutlet weak var editProfileImageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
