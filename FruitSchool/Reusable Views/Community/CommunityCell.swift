//
//  CommunityCell.swift
//  FruitSchool
//
//  Created by 박주현 on 06/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

class CommunityCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButtom: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "CommunityImageCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        // Initialization code
    }


    
}
