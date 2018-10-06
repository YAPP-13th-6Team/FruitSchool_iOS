//
//  UserInfoResponse.swift
//  FruitSchool
//
//  Created by 이재은 on 06/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct UserInfoResponse: Codable {
    struct Data: Codable {
        let grade: Int
        let id: String
        let nickname: String
        let profileImage: String
        enum CodingKeys: String, CodingKey {
            case grade
            case id = "_id"
            case nickname
            case profileImage = "profile_image"
        }
    }
    let message: String
    let data: [Data]
}
