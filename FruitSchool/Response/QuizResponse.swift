//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

struct QuizResponse: Codable {
    //let level: Int      //몇개 난이도가 있을까?
    let title: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
