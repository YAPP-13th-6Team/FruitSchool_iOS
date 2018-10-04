//
//  ExamResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct ExamResponse: Codable {
    struct Data: Codable {
        let id: String
        let title: String
        let correctAnswer: String
        let incorrectAnswers: [String]
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title, correctAnswer, incorrectAnswers
        }
    }
    let message: String
    let data: [Data]
}
