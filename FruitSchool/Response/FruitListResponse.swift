//
//  FruitListResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct FruitListResponse: Codable {
    struct Data: Codable {
        let id: String
        let title: String
        let grade: Int
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title, grade
        }
    }
    let message: String
    let data: [Data]
}
