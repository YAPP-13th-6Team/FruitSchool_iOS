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
    @IBOutlet weak var editNickNameButton: UIButton!
    @IBOutlet weak var editProfileImageButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setProperties(_ object: UserInfoResponse.Data?) {
        guard let object = object else { return }
        nickNameLabel.text = object.nickname
        gradeLabel.text = Grade(rawValue: object.grade)?.expression
        print(object.userId)
        let imageUrl = object.profileImage
        guard let url = URL(string: imageUrl) else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        profileImageView.image = UIImage(data: data)
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
