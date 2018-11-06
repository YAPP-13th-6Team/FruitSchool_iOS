//
//  Network.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

class Network {
    /// 일반적인 HTTP GET 통신 래퍼
    ///
    /// - Parameters:
    ///   - urlPath: 접속할 URL 문자열
    ///   - successHandler: 통신 성공시 호출할 핸들러
    ///   - errorHandler: 에러 발생시 호출할 핸들러
    static func get(_ urlPath: String, successHandler: ((Data, Int) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: urlPath) else { return }
        let task = session.dataTask(with: url) { data, response, error in
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
