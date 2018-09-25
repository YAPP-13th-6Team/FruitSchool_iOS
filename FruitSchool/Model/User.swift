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
    
    /// CREATE User
    static func add(id: Double, nickname: String) {
        if User.fetch().isEmpty {
            let realm = try! Realm()
            let object = User()
            object.id = id
            object.nickname = nickname
            try! realm.write {
                realm.add(object)
            }
        }
    }
    /// READ User
    static func fetch() -> Results<User> {
        let realm = try! Realm()
        let users = realm.objects(User.self)
        return users
    }
    /// UPDATE User
    static func update(_ object: User, keyValue: [String: Any]) {
        let realm = try! Realm()
        try! realm.write {
            for (key, value) in keyValue {
                object.setValue(value, forKey: key)
            }
        }
    }
    /// DELETE User
    static func delete() {
        let realm = try! Realm()
        guard let user = User.fetch().first else { return }
        try! realm.write {
            realm.delete(user)
        }
    }
}
