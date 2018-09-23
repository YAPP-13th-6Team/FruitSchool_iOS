//
//  FruitResponse.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 17..
//  Copyright © 2018년 YAPP. All rights reserved.
//

struct FruitResponse: Codable {
    let id: String
    let title: String
    let grade: Int      //0: 서당개, 1: 학도, 2: 훈장
    let category: String
    let calorie: Double
    let season: String
    let standardTip: StandardTip
    let intakeTip: IntakeTip
    let nutritionTip: NutritionTip
    let quizs: [QuizTip]
    var calorieText: String {
        return "\(calorie)kcal/100g"
    }
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, grade, category, calorie, season, standardTip, intakeTip, nutritionTip, quizs
    }
}

struct StandardTip: Codable {
    let purchasingTip: String
    let storageTemperature: String?
    let storageDate: String?
    let storageMethod: String?
    let careMethod: String?
    var purchasingTipText: String {
        return "구입 요령 : \(purchasingTip)\n"
    }
    var storageTemperatureText: String {
        if let storageTemperature = storageTemperature {
            return "보관 온도 : \(storageTemperature)\n"
        } else {
            return ""
        }
    }
    var storageDateText: String {
        if let storageDate = storageDate {
            return "보관일 : \(storageDate)\n"
        } else {
            return ""
        }
    }
    var storageMethodText: String {
        if let storageMethod = storageMethod {
            return "보관법 : \(storageMethod)\n"
        } else {
            return ""
        }
    }
    var careMethodText: String {
        if let careMethod = careMethod {
            return "손질법 : \(careMethod)"
        } else {
            return ""
        }
    }
}

struct IntakeTip: Codable {
    let intakeMethod: String
    let chemistry: String?
    let precaution: String?
    let diet: String?
    let effect: String?
    var intakeMethodText: String {
        return "섭취 방법 : \(intakeMethod)\n"
    }
    var chemistryText: String {
        if let chemistry = chemistry {
            return "궁합 음식 정보 : \(chemistry)\n"
        } else {
            return ""
        }
    }
    var precautionText: String {
        if let precaution = precaution {
            return "주의사항 : \(precaution)\n"
        } else {
            return ""
        }
    }
    var dietText: String {
        if let diet = diet {
            return "다이어트 : \(diet)\n"
        } else {
            return ""
        }
    }
    var effectText: String {
        if let effect = effect {
            return "효능 : \(effect)"
        } else {
            return ""
        }
    }
}

struct NutritionTip: Codable {
    let sodium: Double
    let protein: Double
    let sugar: Double
    var sodiumText: String {
        return "\(sodium)mg"
    }
    var proteinText: String {
        return "\(protein)g"
    }
    var sugarText: String {
        return "\(sugar)g"
    }
}

struct QuizTip: Codable {
    let title: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}
