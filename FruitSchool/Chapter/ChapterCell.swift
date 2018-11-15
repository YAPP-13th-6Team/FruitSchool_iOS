//
//  GuideBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

class ChapterCell: UICollectionViewCell {

    var blurView: UIView?
    var lockImageView: UIImageView?
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.backgroundColor = .gray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        lockImageView?.removeFromSuperview()
        blurView?.removeFromSuperview()
    }
    
    func setProperties(_ object: FruitListResponse.Data, grade: Int, isPassed: Bool) {
        imageView.image = UIImage(named: object.english.toImageName(grade: grade, isDetail: false))
        if !isPassed {
            let blurEffect = UIBlurEffect(style: .prominent)
            blurView = UIVisualEffectView(effect: blurEffect)
            guard let blurView = blurView else { return }
            blurView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
                blurView.topAnchor.constraint(equalTo: topAnchor),
                blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
            guard let lockImageView = lockImageView else { return }
            lockImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(lockImageView)
            NSLayoutConstraint.activate([
                lockImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                lockImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
        }
    }
}
