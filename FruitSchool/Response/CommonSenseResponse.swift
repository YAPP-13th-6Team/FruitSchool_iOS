//
//  CommonSenseResponse.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 21..
//  Copyright © 2018년 YAPP. All rights reserved.
//

struct CommonSenseResponse: Codable {
    let id: String
    let grade: Int
    let commonSenseTips: [CommonSenseTip]
    let quizs: [QuizTip]
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case grade, commonSenseTips, quizs
    }
}

struct CommonSenseTip: Codable {
    let title: String
    let content: String
}
