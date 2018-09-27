//
//  Notification.Name.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

extension Notification.Name {
    // MARK: 과일 정보 가져오기 관련
    static let didReceiveFruits = Notification.Name("DidReceiveFruits")
    static let errorReceiveFruits = Notification.Name("ErrorReceiveFruits")
    // MARK: 상식 정보 가져오기 관련
    static let didReceiveCommonSenses = Notification.Name("DidRecieveCommonSenses")
    static let errorReceiveCommonSenses = Notification.Name("ErrorReceiveCommonSenses")
    // MARK: 서버에 사용자 등록 관련
    static let didReceiveCreatingUser = Notification.Name("DidReceiveCreatingUser")
    static let errorReceiveCreatingUser = Notification.Name("ErrorReceiveCreatingUser")
    static let didReceiveDuplicatedUser = Notification.Name("DidReceiveDuplicatedUser")
    static let errorReceiveDuplicatedUser = Notification.Name("ErrorReceiveDuplicatedUser")
    // MARK: 서버 사용자 등급 정보 조정 관련
    static let didReceiveUpdatingUserGrade = Notification.Name("DidReceiveUpdatingUserGrade")
    static let errorReceiveUpdatingUserGrade = Notification.Name("ErrorReceiveUpdatingUserGrade")
}
