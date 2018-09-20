//
//  FruitResponse.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

struct FruitResponse: Codable {
    let title: String
    let grade: Int      //0: 서당개, 1: 학도, 2: 훈장
    let category: String
    let calorie: Double
    let standardInfo: StandardInfo
    let intakeInfo: IntakeInfo
    let nutritionInfo: NutritionInfo
    let quizs: [QuizInfo]
}

struct StandardInfo: Codable {
    let purchasingTip: String?
    let storageTemperature: String?
    let storageDate: String?
    let storageMethod: String?
    let careMethod: String?
}

struct IntakeInfo: Codable {
    let intakeMethod: String?
    let chemistry: String?
    let diet: String?
    let effect: String?
}

struct NutritionInfo: Codable {
    let sodium: Double
    let protein: Double
    let sugar: Double
}

struct QuizInfo: Codable {
    let title: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
