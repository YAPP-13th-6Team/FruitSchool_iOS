//
//  BookCell.swift
//  
//
//  Created by Presto on 19/11/2018.
//

import UIKit
import FSPagerView

class BookCell: FSPagerViewCell {

    @IBOutlet var coverImageView: UIImageView!
    
    @IBOutlet var stampImageView: UIImageView!
    
    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        coverImageView.image = nil
        stampImageView.image = nil
    }
    
    func setProperties(at index: Int, isPassed: Bool, isPassedCompletely: Bool) {
        let allImageNames = BookCoverImage.all
        if isPassedCompletely {
            coverImageView.image = UIImage(named: allImageNames[index][1])
            stampImageView.image = UIImage(named: "stamp_clear")
        } else {
            coverImageView.image = isPassed ? UIImage(named: allImageNames[index][1]) : UIImage(named: allImageNames[index][0])
            stampImageView.image = nil
        }
    }
}
