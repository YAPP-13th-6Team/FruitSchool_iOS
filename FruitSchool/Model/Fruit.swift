//
//  Fruit.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import RealmSwift

@objcMembers
class Record: Object {
    dynamic var id: String = ""
    dynamic var isPassed: Bool = false
    /**
     Record 레코드 생성.
     - Parameter id: 과일의 고유 아이디
    */
    static func add(id: String) {
        let realm = try! Realm()
        let record = Record()
        record.id = id
        try! realm.write {
            realm.add(record)
        }
    }
    ///Record 가져오기.
    static func fetch() -> Results<Record> {
        let realm = try! Realm()
        return realm.objects(Record.self)
    }
    /**
     Record의 특정 레코드의 특정 필드 갱신.
     - Parameter object: 특정 레코드
     - Parameter keyValue: 레코드의 특정 필드와 갱신할 값. 딕셔너리.
    */
    static func update(_ object: Record, keyValue: [String: Any]) {
        let realm = try! Realm()
        for (key, value) in keyValue {
            try! realm.write {
                object.setValue(value, forKey: key)
            }
        }
    }
    ///Record의 특정 레코드 삭제.
    static func remove(_ object: Record) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
}
