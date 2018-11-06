//
//  LoginResponse.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 카카오 로그인 연동시 사용되는 응답 모델
 authorization을 키체인에 저장하여 통신에 사용한다
 */
struct LoginResponse: Codable {
    struct Data: Codable {
        let id: String
        let authorization: String
    }
    let message: String
    let data: Data
}
