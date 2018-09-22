//
//  User.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import RealmSwift

@objcMembers
class User: Object {
    
    dynamic var id: Double = 0
    dynamic var nickname: String = ""
    dynamic var grade: Int = 0
     
}
