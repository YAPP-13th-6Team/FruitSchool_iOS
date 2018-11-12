//
//  Int+.swift
//  FruitSchool
//
//  Created by Presto on 12/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

extension Int {
    var toOrdinalExpression: String {
        var result: String = ""
        let numberOfDecimalPlace = self / 10
        let numberOfOnePlace = self % 10
        switch numberOfDecimalPlace {
        case 1:
            result += "열 "
        case 2:
            result += "스물 "
        case 3:
            result += "서른 "
        case 4:
            result += "마흔 "
        case 5:
            result += "쉰 "
        case 6:
            result += "예순 "
        case 7:
            result += "일흔 "
        case 8:
            result += "여든 "
        case 9:
            result += "아흔 "
        default:
            break
        }
        switch numberOfOnePlace {
        case 1 where numberOfDecimalPlace > 0:
            result += "한 "
        case 1 where numberOfDecimalPlace == 0:
            result += "첫 "
        case 2:
            result += "두 "
        case 3:
            result += "세 "
        case 4:
            result += "네 "
        case 5:
            result += "다섯 "
        case 6:
            result += "여섯 "
        case 7:
            result += "일곱 "
        case 8:
            result += "여덟 "
        case 9:
            result += "아홉 "
        default:
            break
        }
        result += "번째 카드"
        return result
    }
}
