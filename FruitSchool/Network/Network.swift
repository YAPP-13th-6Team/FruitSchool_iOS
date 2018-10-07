//
//  Network.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

class Network {
    /// HTTP GET 통신 래퍼
    ///
    /// - Parameters:
    ///   - urlPath: 접속할 URL 문자열
    ///   - successHandler: 통신 성공시 호출할 핸들러
    ///   - errorHandler: 에러 발생시 호출할 핸들러
    static func get(_ urlPath: String, successHandler: ((Data, Int) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlPath) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.string(forKey: "authorization"), forHTTPHeaderField: "authorization")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                errorHandler?(error)
                session.finishTasksAndInvalidate()
                return
            }
            guard let data = data else { return }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            successHandler?(data, statusCode)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }

    /// HTTP POST 통신 래퍼
    ///
    /// - Parameters:
    ///   - urlPath: 접속할 URL 문자열
    ///   - parameters: HTTP Body에 들어갈 키/값의 배열. 딕셔너리
    ///   - successHandler: 통신 성공시 호출할 핸들러
    ///   - errorHandler: 에러 발생시 호출할 핸들러
    static func post(_ urlPath: String, parameters: [String: Any], successHandler: ((Data, Int) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                errorHandler?(error)
                session.finishTasksAndInvalidate()
                return
            }
            guard let data = data else { return }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            successHandler?(data, statusCode)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
    
    /// 로그인시 토큰 발급에 사용되는 HTTP POST 통신 래퍼
    ///
    /// - Parameters:
    ///   - urlPath: 접속할 URL 문자열
    ///   - parameters: HTTP Body에 들어갈 키/값의 배열. 딕셔너리
    ///   - successHandler: 통신 성공시 호출할 핸들러
    ///   - errorHandler: 에러 발생히 호출할 핸들러
    /// - Note: 토근 발급 통신시 application/json이 아닌 application/x-www-form-urlencoded 방식으로 Body에 값을 넣어 요청한다.
    static func postForLogin(_ urlPath: String, parameters: [String: Any], successHandler: ((Data, Int) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlPath) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        guard let token = (parameters["access_token"]) as? String else { return }
        let body = "access_token=\(token)"
        request.httpBody = body.data(using: .utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                errorHandler?(error)
                session.finishTasksAndInvalidate()
                return
            }
            guard let data = data else { return }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            successHandler?(data, statusCode)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
}
