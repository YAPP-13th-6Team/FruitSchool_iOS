//
//  API+Community.swift
//  FruitSchool
//
//  Created by 박주현 on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

extension API {
    static func requestCommunityList(completion: @escaping (CommunityListResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/posts/lists/sort/0", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(CommunityListResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
}
