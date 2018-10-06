//
//  Fruit.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import RealmSwift

@objcMembers
class ChapterRecord: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var grade: Int = 0
    dynamic var isPassed: Bool = false
    
    /// ChapterRecord 레코드 생성.
    ///
    /// - Parameter id: 과일의 고유 아이디
    static func add(id: String, title: String, grade: Int) {
        let realm = try! Realm()
        let record = ChapterRecord()
        record.id = id
        record.title = title
        record.grade = grade
        try! realm.write {
            realm.add(record)
        }
    }
    /// ChapterRecord 가져오기.
    ///
    /// - Returns: 모든 ChapterRecord 레코드.
    static func fetch() -> Results<ChapterRecord> {
        let realm = try! Realm()
        return realm.objects(ChapterRecord.self)
    }
    /// ChapterRecord의 특정 레코드의 특정 필드 갱신.
    ///
    /// - Parameters:
    ///   - object: 특정 레코드
    ///   - keyValue: 레코드의 특정 필드와 갱신할 값.
    static func update(_ object: ChapterRecord, keyValue: [String: Any]) {
        let realm = try! Realm()
        for (key, value) in keyValue {
            try! realm.write {
                object.setValue(value, forKey: key)
            }
        }
    }
    /// ChapterRecord의 특정 레코드 삭제.
    ///
    /// - Parameter object: 삭제할 ChapterRecord 레코드
    static func remove(_ object: ChapterRecord) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
}