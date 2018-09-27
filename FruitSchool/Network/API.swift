//
//  API.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

class API {
    //private static let baseURL = "http://localhost:3000"
    private static let baseURL = "http://ec2-13-125-249-84.ap-northeast-2.compute.amazonaws.com:3000"
    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}

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
    /**
     서버에 회원 정보 업로드.
     - Parameter id: 카카오 고유 ID
     - Parameter nickname: 사용자가 입력한 닉네임
    */
    static func requestCreatingUser(id: String, nickname: String) {
        let parameter = ["id": id, "nickname": nickname]
        Network.post("\(baseURL)/users/user", parameters: parameter, successHandler: { (data, statusCode) in
            if (400...499).contains(statusCode) {
                NotificationCenter.default.post(name: .errorReceiveCreatingUser, object: nil)
            } else {
                NotificationCenter.default.post(name: .didReceiveCreatingUser, object: nil)
            }
        }, errorHandler: { (error) in
            NotificationCenter.default.post(name: .errorReceiveCreatingUser, object: nil)
        })
    }
    /**
     사용자 중복 확인.
     - Parameter id: 카카오 고유 ID
     - Note: 409 Conflict 에러는 중복 사용자임을 의미.
    */
    static func requestCheckingDuplicatedUser(id: String) {
        let parameter = ["id": id]
        Network.post("\(baseURL)/users/duplicated", parameters: parameter, successHandler: { (data, statusCode) in
            if statusCode == 409 {
                NotificationCenter.default.post(name: .didReceiveDuplicatedUser, object: nil, userInfo: ["isDuplicated": true])
            } else {
                NotificationCenter.default.post(name: .didReceiveDuplicatedUser, object: nil, userInfo: ["isDuplicated": false ,"id": id])
            }
        }, errorHandler: { (error) in
            NotificationCenter.default.post(name: .errorReceiveDuplicatedUser, object: nil)
        })
    }
    /**
     서버에 있는 사용자 등급 정보 수정.
     - Parameter id: 카카오 고유 ID
     - Parameter grade: 새로운 등급
    */
    static func requestUpdatingUserGrade(id: String, grade: Int) {
        let parameter: [String: Any] = ["id": id, "grade": grade]
        Network.post("\(baseURL)/users/grade", parameters: parameter, successHandler: { (data, statusCode) in
            if (400...499).contains(statusCode) {
                NotificationCenter.default.post(name: .errorReceiveUpdatingUserGrade, object: nil)
            } else {
                NotificationCenter.default.post(name: .didReceiveUpdatingUserGrade, object: nil)
            }
        }, errorHandler: { (error) in
            NotificationCenter.default.post(name: .errorReceiveUpdatingUserGrade, object: nil)
        })
    }
}
