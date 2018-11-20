//
//  Constants.swift
//  FruitSchool
//
//  Created by Presto on 20/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct BookCoverImage {
    static let dogUnclear = "cover_dog_unclear"
    static let dogClear = "cover_dog_clear"
    static let studentUnclear = "cover_student_unclear"
    static let studentClear = "cover_student_clear"
    static let bossUnclear = "cover_boss_unclear"
    static let bossClear = "cover_boss_clear"
    static var all: [[String]] {
        return [[dogUnclear, dogClear], [studentUnclear, studentClear], [bossUnclear, bossClear]]
    }
}

enum ChapterTopImage: String, CaseIterable {
    case dog = "dog_top"
    case student = "student_top"
    case boss = "boss_top"
}

enum ChapterClearImage: String, CaseIterable {
    case dog = "dog_clear"
    case student = "student_clear"
    case boss = "boss_clear"
}
