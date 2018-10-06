//
//  API.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

enum APIError: Error {
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
// MARK: - 메인 플로우 관련
extension API {
    /// 모든 과일 정보 요청.
    ///
    /// - Parameters:
    ///   - completion: 컴플리션 핸들러
    static func requestFruits(completion: @escaping (FruitResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(FruitResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
    /// 특정 id의 과일 정보 요청
    ///
    /// - Parameters:
    ///   - id: 과일 고유 id
    ///   - completion: 컴플리션 핸들러
    /// - Note: 디코딩된 값의 data 프로퍼티는 Array이지만 항상 한 개의 요소만 가지므로 first 프로퍼티로 접근하여 사용한다.
    static func requestFruit(by id: String, completion: @escaping (FruitResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits/\(id)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(FruitResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
    /// 모든 과일의 리스트 요청. 챕터 화면을 그릴 때 사용한다.
    ///
    /// - Parameter completion: 컴플리션 핸들러
    static func requestFruitList(completion: @escaping (FruitListResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits/lists", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(FruitListResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
    /// 특정 과일의 문제 정보 요청.
    ///
    /// - Parameters:
    ///   - id: 과일 고유 id
    ///   - completion: 컴플리션 핸들러
    static func requestExercises(by id: String, completion: @escaping (ExerciseResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits/exercises/\(id)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(ExerciseResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
    /// 등급에 따른 승급심사 정보 요청.
    ///
    /// - Parameters:
    ///   - grade: 사용자 등급
    ///   - completion: 컴플리션 핸들러
    static func requestExam(by grade: Int, completion: @escaping (ExamResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/fruits/exams/\(grade)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(ExamResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
}
// MARK: - 사용자 관리 관련
extension API {
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
    /// 특정 id의 사용자 정보 요청
    ///
    /// - Parameters:
    ///   - id: 카카오 고유 id
    ///   - completion: 컴플리션 핸들러
    static func requestUserInfo(by id: String, completion: @escaping (UserInfoResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/users/mypage/\(id)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(UserInfoResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
}
