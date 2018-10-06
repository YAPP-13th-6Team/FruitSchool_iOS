//
//  Network.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

class Network {
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
            print(statusCode)
            successHandler?(data, statusCode)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
}
