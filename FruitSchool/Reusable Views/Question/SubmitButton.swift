//
//  SubmitButton.swift
//  FruitSchool
//
//  Created by Presto on 20/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import UIKit

@IBDesignable
class SubmitButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
        setTitleColor(.black, for: [])
        setTitle("제출하기", for: [])
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    }
}
