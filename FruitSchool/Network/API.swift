//
//  API.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

class API {
    private static let baseURL = "http://localhost:3000"
    //private static let baseURL = "http://ec2-13-125-249-84.ap-northeast-2.compute.amazonaws.com"
    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}

// MARK: - Guide Book
extension API {
    ///과일 정보 요청.
    static func requestFruits() {
        Network.get("\(baseURL)/fruits", successHandler: { data in
            do {
                let decoded = try jsonDecoder.decode([FruitResponse].self, from: data)
                NotificationCenter.default.post(name: .didReceiveFruits, object: nil, userInfo: ["fruits": decoded])
            } catch {
                NotificationCenter.default.post(name: .errorReceiveFruits, object: nil, userInfo: ["error": error.localizedDescription])
            }
        }, errorHandler: { error in
            NotificationCenter.default.post(name: .errorReceiveFruits, object: nil, userInfo: ["error": error.localizedDescription])
        })
    }
    /**
     상식 정보 요청.
     - Parameter grade: 등급 (0: 서당개 / 1: 학도 / 2: 훈장).
     - Note: 잘못된 등급이 인자로 넘어가면 에러 노티피케이션 포스트.
    */
    static func requestCommonSenses(grade: Int) {
        if !(0...2).contains(grade) {
            NotificationCenter.default.post(name: .errorReceiveCommonSenses, object: nil, userInfo: ["error": "올바르지 않은 요청"])
            return
        }
        Network.get("\(baseURL)/commonSenses/\(grade)", successHandler: { data in
            do {
                let decoded = try jsonDecoder.decode(CommonSenseResponse.self, from: data)
                NotificationCenter.default.post(name: .didReceiveCommonSenses, object: nil, userInfo: ["commonSenses": decoded])
            } catch {
                NotificationCenter.default.post(name: .errorReceiveCommonSenses, object: nil, userInfo: ["error": error.localizedDescription])
            }
        }, errorHandler: { error in
            NotificationCenter.default.post(name: .errorReceiveCommonSenses, object: nil, userInfo: ["error": error.localizedDescription])
        })
    }
}
