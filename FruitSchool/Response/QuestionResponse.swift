//
//  QuizResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 문제 응답 모델
 Exercise, PromotionReview에서 공통적으로 사용됨
 */
struct QuestionResponse: Codable {
    let title: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
