//
//  LoginResponse.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct LoginResponse: Codable {
    struct Data: Codable {
        let id: String
        let authorization: String
    }
    let message: String
    let data: Data
}
