//
//  ExamResponse.swift
//  FruitSchool
//
//  Created by Presto on 04/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 승급심사 문제 응답 모델
 */
struct PromotionReviewResponse: Codable {
    let message: String
    let data: [QuestionResponse]
}
