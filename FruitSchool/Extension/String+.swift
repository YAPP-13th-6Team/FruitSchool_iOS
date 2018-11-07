//
//  String+.swift
//  FruitSchool
//
//  Created by Presto on 07/11/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

extension String {
    var toImageName: String {
        let lowercased = self.lowercased()
        let splitted = lowercased.split(separator: " ").map { String($0) }
        var result = ""
        let count = splitted.count
        for index in 0..<count - 1 {
            result += splitted[index] + "_"
        }
        result += splitted.last ?? ""
        return result
    }
}
