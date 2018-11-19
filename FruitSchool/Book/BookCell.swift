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
    
    override func prepareForReuse() {
        coverImageView.image = nil
        stampImageView.image = nil
    }
}
