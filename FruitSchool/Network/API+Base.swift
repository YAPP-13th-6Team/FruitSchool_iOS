//
//  API+Base.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import Foundation

class API {
    static let baseURL = "http://localhost:3000"
    //static let baseURL = "http://13.125.249.84:3000"
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}
