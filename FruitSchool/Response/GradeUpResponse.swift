//
//  GradeUpResponse.swift
//  FruitSchool
//
//  Created by Presto on 09/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 승급심사 통과시 통신에 사용되는 응답 모델
 */
struct GradeUpResponse: Codable {
    let message: String
    let data: Int
}
