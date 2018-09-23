//
//  UserResponse.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 20..
//  Copyright © 2018년 YAPP. All rights reserved.
//

struct UserResponse: Codable {
    let id: String
    let identifier: Double
    let nickname: String
    let grade: Int
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case identifier, nickname, grade
    }
}
