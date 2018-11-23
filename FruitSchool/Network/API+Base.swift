//
//  API+Base.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import Foundation

/*
 API의 기본 형태
 Base URL과 JSONDecoder의 디코딩 전략 설정
 */
class API {
    //static let baseURL = "http://localhost:3000"
    static let baseURL = "http://168.62.38.254:3000"
    static let imageBaseURL = "https://fruits2.blob.core.windows.net/fruits/"
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}
