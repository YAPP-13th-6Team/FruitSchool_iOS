//
//  CommonSenseResponse.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 21..
//  Copyright © 2018년 YAPP. All rights reserved.
//

struct CommonSenseResponse: Codable {
    let grade: Int
    let commonSenseTips: [CommonSenseTip]
    let quizs: [QuizTip]
}

struct CommonSenseTip: Codable {
    let title: String
    let content: String
}
