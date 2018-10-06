//
//  BookRecord.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import RealmSwift

@objcMembers
class UserRecord: Object {
    
    dynamic var passesDog: Bool = false
    dynamic var passesStudent: Bool = false
    dynamic var passesBoss: Bool = false
    
    /// BookRecord 생성.
    static func add() {
        let realm = try! Realm()
        let record = UserRecord()
        try! realm.write {
            realm.add(record)
        }
    }
    
    /// BookRecord 가져오기.
    ///
    /// - Returns: 모든 BookRecord 레코드.
    /// - Note: BookRecord는 단 하나의 레코드만을 갖는다.
    static func fetch() -> Results<UserRecord> {
        let realm = try! Realm()
        return realm.objects(UserRecord.self)
    }
    
    /// BookRecord의 특정 레코드의 특정 필드 갱신.
    ///
    /// - Parameters:
    ///   - object: 특정 레코드
    ///   - keyValue: 레코드의 특정 필드와 갱신할 값.
    static func update(_ object: UserRecord, keyValue: [String: Any]) {
        let realm = try! Realm()
        for (key, value) in keyValue {
            try! realm.write {
                object.setValue(value, forKey: key)
            }
        }
    }
    
    /// BookRecord의 특정 레코드 삭제.
    ///
    /// - Parameter object: 삭제할 BookRecord 레코드.
    static func remove(_ object: UserRecord) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
}
