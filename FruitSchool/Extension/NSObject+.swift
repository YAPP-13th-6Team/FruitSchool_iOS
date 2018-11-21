//
//  NSObject+.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 4..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import UIKit
import Foundation

enum DeviceModel {
    case iPhone
    case iPad
}

extension NSObject {
    var deviceModel: DeviceModel {
        let model = UIDevice.current.model
        if model == "iPhone" {
            return .iPhone
        } else {
            return .iPad
        }
    }
    
    var classNameToString: String {
        return NSStringFromClass(type(of: self))
    }
    
    static var classNameToString: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
