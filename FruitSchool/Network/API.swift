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
    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}

// MARK:- Guide Book
extension API {
    static func requestFruits(id: String = "") {
        Network.get("\(baseURL)/fruits/\(id)", successHandler: { (data) in
            if id.isEmpty {
                do {
                    let decoded = try jsonDecoder.decode([FruitResponse].self, from: data)
                    NotificationCenter.default.post(name: .didReceiveFruits, object: nil, userInfo: ["fruits": decoded])
                } catch {
                    NotificationCenter.default.post(name: .errorReceiveFruits, object: nil, userInfo: ["error": error.localizedDescription])
                }
            } else {
                do {
                    let decoded = try jsonDecoder.decode(FruitResponse.self, from: data)
                    NotificationCenter.default.post(name: .didReceiveFruits, object: nil, userInfo: ["fruit": decoded])
                } catch {
                    NotificationCenter.default.post(name: .errorReceiveFruits, object: nil, userInfo: ["error": error.localizedDescription])
                }
            }
        }, errorHandler: { (error) in
            NotificationCenter.default.post(name: .errorReceiveFruits, object: nil, userInfo: ["error": error.localizedDescription])
        })
    }
}
