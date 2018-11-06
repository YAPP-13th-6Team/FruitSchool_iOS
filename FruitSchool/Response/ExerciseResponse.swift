//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 01/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 과일 문제 응답 모델
 */
struct ExerciseResponse: Codable {
    struct Data: Codable {
        let id: String
        let title: String
        let quizs: [ExerciseQuestionResponse]
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case title, quizs
        }
    }
    let message: String
    let data: Data
}

struct ExerciseQuestionResponse: Codable {
    let fruitTitle: String
    let fruitId: String
    let incorrectAnswers: [String]
    let correctAnswer: String
    let title: String
}
