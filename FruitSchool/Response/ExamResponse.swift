//
//  ExamResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct ExamResponse: Codable {
    let message: String
    let data: [QuizResponse]
}
