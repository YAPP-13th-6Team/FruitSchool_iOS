//
//  API.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

/*
 과일과 관련된 API
 */
extension API {
    /// 특정 id의 과일 정보 요청
    ///
    /// - Parameters:
    ///   - id: 과일 고유 id
    ///   - completion: 컴플리션 핸들러
    /// - Note: 디코딩된 값의 data 프로퍼티는 Array이지만 항상 한 개의 요소만 가지므로 first 프로퍼티로 접근하여 사용한다.
    static func requestFruit(by id: String, completion: @escaping (FruitResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/\(id)", successHandler: { data, statusCode in
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
        Network.get("\(baseURL)/lists", successHandler: { data, statusCode in
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
    static func requestExercises(by id: String, completion: @escaping (QuestionResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/exercises/\(id)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(QuestionResponse.self, from: data)
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
    static func requestExam(by grade: Int, completion: @escaping (QuestionResponse?, Int?, Error?) -> Void) {
        Network.get("\(baseURL)/exams/\(grade)", successHandler: { data, statusCode in
            do {
                let decoded = try jsonDecoder.decode(QuestionResponse.self, from: data)
                completion(decoded, statusCode, nil)
            } catch {
                completion(nil, statusCode, error)
            }
        }, errorHandler: { error in
            completion(nil, nil, error)
        })
    }
}
