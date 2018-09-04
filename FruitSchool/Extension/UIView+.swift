//
//  UIView+.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 4..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit

extension UIView {
    static func instantiateFromXib(xibName: String) -> UIView? {
        return UINib(nibName: xibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
        
    }
}
