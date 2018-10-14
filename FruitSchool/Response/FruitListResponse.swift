//
//  FruitListResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 교과서 내 과일 목록 응답 모델
 */
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
