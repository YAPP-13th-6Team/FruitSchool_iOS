//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 문제 응답 모델
 */
struct QuestionResponse: Codable {
    struct Data: Codable {
        struct Question: Codable {
            let fruitTitle: String
            let fruitId: String
            let title: String
            let correctAnswer: String
            let incorrectAnswers: [String]
        }
        let quizs: [QuestionResponse]
    }
    let message: String
    let data: Data
}
