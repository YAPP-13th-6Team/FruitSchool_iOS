//
//  NSObject+.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 4..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

extension NSObject {
    var classNameToString: String {
        return NSStringFromClass(type(of: self))
    }
    
    static var classNameToString: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    var regionCode: String {
        return Locale.current.regionCode ?? ""
    }
}
