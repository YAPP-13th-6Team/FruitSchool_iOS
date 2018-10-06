//
//  API+Auth.swift
//  FruitSchool
//
//  Created by Presto on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

extension API {
    /// 토큰 발급.
    ///
    /// - Parameters:
    ///   - token: 토큰
    ///   - completion: 컴플리션 핸들러
    static func requestAuthorization(token: String, completion: @escaping (LoginResponse?, Int?, Error?) -> Void) {
        let parameters = ["access_token": token]
        Network.postForLogin("\(baseURL)/users/kakao/signin", parameters: parameters, successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(LoginResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
}
