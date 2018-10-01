//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 01/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct QuizResponse: Codable {
    let title: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
