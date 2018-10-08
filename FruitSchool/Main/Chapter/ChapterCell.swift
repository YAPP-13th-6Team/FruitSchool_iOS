//
//  GuideBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class ChapterCell: UICollectionViewCell {
    
    let blurViewTag = 99
    let lockImageViewTag = 100
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .gray
        nameLabel.backgroundColor = .lightGray
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        viewWithTag(blurViewTag)?.removeFromSuperview()
        viewWithTag(lockImageViewTag)?.removeFromSuperview()
    }
    
    func setProperties(_ object: FruitListResponse.Data, isPassed: Bool) {
        if !isPassed {
            viewWithTag(blurViewTag)?.removeFromSuperview()
            let blurEffect = UIBlurEffect(style: .regular)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.tag = blurViewTag
            blurView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.topAnchor.constraint(equalTo: topAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            viewWithTag(lockImageViewTag)?.removeFromSuperview()
            let lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
            lockImageView.tag = lockImageViewTag
            lockImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(lockImageView)
            NSLayoutConstraint.activate([
                lockImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                lockImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        }
        nameLabel.text = object.title
    }
}
