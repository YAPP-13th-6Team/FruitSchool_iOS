//
//  GuideBookCell.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import SnapKit

class ChapterCell: UICollectionViewCell {

    private var blurView: UIView?
    
    private var lockImageView: UIImageView?
    
    @IBOutlet private weak var imageView: UIImageView!
    
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
            addSubview(blurView)
            blurView.snp.makeConstraints { maker in
                maker.edges.equalTo(self)
            }
            lockImageView = UIImageView(image: #imageLiteral(resourceName: "lock"))
            guard let lockImageView = lockImageView else { return }
            addSubview(lockImageView)
            lockImageView.snp.makeConstraints { maker in
                maker.center.equalTo(snp.center)
            }
        }
    }
}
