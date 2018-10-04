//
//  Grade.swift
//  FruitSchool
//
//  Created by Presto on 30/09/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

enum Grade: Int {
    case dog = 0
    case student = 1
    case teacher = 2
    var expression: String {
        switch self {
        case .dog:
            return "서당개"
        case .student:
            return "학도"
        case .teacher:
            return "훈장"
        }
    }
}
