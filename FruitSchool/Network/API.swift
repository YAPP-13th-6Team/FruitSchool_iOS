//
//  API.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidGradeError
}

class API {
    //private static let baseURL = "http://localhost:3000"
    private static let baseURL = "http://13.125.249.84:3000"
    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}

extension API {
    ///과일 정보 요청.
    static func requestFruits(grade: Int? = nil, completion: @escaping ([FruitResponse]?, Error?) -> Void) {
        guard let grade = grade else {
            Network.get("\(baseURL)/fruits", successHandler: { (data, statusCode) in
                do {
                    let decoded = try jsonDecoder.decode([FruitResponse].self, from: data)
                    completion(decoded, nil)
                } catch {
                    completion(nil, error)
                }
            }, errorHandler: { error in
                completion(nil, error)
            })
            return
        }
        Network.get("\(baseURL)/fruits?grade=\(grade)", successHandler: { (data, statusCode) in
            do {
                let decoded = try jsonDecoder.decode([FruitResponse].self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, errorHandler: { error in
            completion(nil, error)
        })
    }
    /**
     특정 과일의 문제 요청.
     - Parameter fruitID: 과일 고유 id
    */
    static func requestQuizs(of fruitID: String, completion: @escaping ([QuizResponse]?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits/\(fruitID)/quizs", successHandler: { (data, statusCode) in
            do {
                let decoded = try jsonDecoder.decode([QuizResponse].self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, errorHandler: { error in
            completion(nil, error)
        })
    }
    /**
     상식 정보 요청.
     - Parameter grade: 등급 (0: 서당개 / 1: 학도 / 2: 훈장).
     - Note: 잘못된 등급이 인자로 넘어가면 에러 던짐.
    */
    static func requestCommonSenses(grade: Int, completion: @escaping (CommonSenseResponse?, Error?) -> Void) {
        if !(0...2).contains(grade) {
            completion(nil, NetworkError.invalidGradeError)
            return
        }
        Network.get("\(baseURL)/commonSenses/\(grade)", successHandler: { (data, statusCode) in
            do {
                let decoded = try jsonDecoder.decode(CommonSenseResponse.self, from: data)
                completion(decoded, nil)
            } catch {
                completion(nil, error)
            }
        }, errorHandler: { error in
            completion(nil, error)
        })
    }
    /**
     서버에 회원 정보 업로드.
     - Parameter id: 카카오 고유 ID
     - Parameter nickname: 카카오 사용자의 닉네임
    */
    static func requestCreatingUser(id: String, nickname: String, completion: @escaping (Int?, Error?) -> Void) {
        let parameter = ["id": id, "nickname": nickname]
        Network.post("\(baseURL)/users/user", parameters: parameter, successHandler: { (_, statusCode) in
            completion(statusCode, nil)
        }, errorHandler: { (error) in
            completion(nil, error)
        })
    }
    /**
     사용자 중복 확인.
     - Parameter id: 카카오 고유 ID
     - Note: 409 Conflict 에러는 중복 사용자임을 의미.
    */
    static func requestCheckingDuplicatedUser(id: String, completion: @escaping (Bool?, Error?) -> Void) {
        let parameter = ["id": id]
        Network.post("\(baseURL)/users/duplicated", parameters: parameter, successHandler: { (_, statusCode) in
            if statusCode == 409 {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }, errorHandler: { (error) in
            completion(nil, error)
        })
    }
    /**
     서버에 있는 사용자 등급 정보 수정.
     - Parameter id: 카카오 고유 ID
     - Parameter grade: 새로운 등급
    */
    static func requestUpdatingUserGrade(id: String, grade: Int, completion: @escaping (Int?, Error?) -> Void) {
        let parameter: [String: Any] = ["id": id, "grade": grade]
        Network.post("\(baseURL)/users/grade", parameters: parameter, successHandler: { (_, statusCode) in
            completion(statusCode, nil)
        }, errorHandler: { (error) in
            completion(nil, error)
        })
    }
}
