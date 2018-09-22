//
//  Notification.Name.swift
//  FruitSchool
//
//  Created by Presto on 2018. 9. 9..
//  Copyright © 2018년 YAPP. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveFruits = Notification.Name("DidReceiveFruits")
    static let errorReceiveFruits = Notification.Name("ErrorReceiveFruits")
    static let didReceiveCommonSenses = Notification.Name("DidRecieveCommonSenses")
    static let errorReceiveCommonSenses = Notification.Name("ErrorReceiveCommonSenses")
}
