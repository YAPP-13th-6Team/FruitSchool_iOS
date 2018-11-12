//
//  String+.swift
//  FruitSchool
//
//  Created by Presto on 07/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

extension String {
    func toImageName(grade: Int) -> String {
        var result = ""
        switch grade {
        case 0:
            result += "dog_"
        case 1:
            result += "student_"
        case 2:
            result += "boss_"
        default:
            break
        }
        let lowercased = self.lowercased()
        let splitted = lowercased.split(separator: " ").map { String($0) }
        let count = splitted.count
        for index in 0..<count - 1 {
            result += splitted[index] + "_"
        }
        result += splitted.last ?? ""
        return result
    }
}
