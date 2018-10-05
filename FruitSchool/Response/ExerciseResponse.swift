//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 01/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct ExerciseResponse: Codable {
    struct Data: Codable {
        let id: String
        let title: String
        let quizs: [QuizResponse]
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title, quizs
        }
    }
    let message: String
    let data: Data
}
