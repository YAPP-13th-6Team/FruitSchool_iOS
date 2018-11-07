//
//  Quiz.swift
//  FruitSchool
//
//  Created by Presto on 06/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

/*
 서버에서 받아온 문제들을 클라이언트에서 잘 주무르기 위한 문제 모델
 */
struct Question {
    let title: String
    let fruitName: String
    let correctAnswer: String
    let answers: [String]
}
