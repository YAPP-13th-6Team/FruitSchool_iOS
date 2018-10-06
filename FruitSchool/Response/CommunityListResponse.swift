//
//  CommunityResponse.swift
//  FruitSchool
//
//  Created by 박주현 on 06/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import Foundation

struct CommunityListResponse: Codable {
    struct Data: Codable {
        let userId: String
        let userGrade: Int
        let userImagePath: String
        let postsId: String
        let postsContent: String
        let postImage: [String]
        let postsTag: [String]
        let commentCount: Int
        let heartCount: Int
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case userGrade = "user_grade"
            case userImagePath = "user_image_path"
            case postsId = "posts_id"
            case postsContent = "posts_content"
            case postImage = "posts_image"
            case postsTag = "posts_tag"
            case commentCount = "comment_count"
            case heartCount = "heart_count"
        }
    }
    let message: String
    let data: [Data]
}

//{
//    “msg”: ” Success get posts list sorted by ${sort}”
//    “data”: [{
//    “user_id”:  (string) – 게시자 id
//    “user_grade”:  (int) – 게시자 등급 ex) 0,1,2
//    “user_image_path”: (string) – 게시자 프로필 링크
//
//    “posts_id” (String) – 게시글 id 
//“posts_content”: (String) – 게시글 내용
//    “posts_image”: (String[]) – 게시글 사진 리스트
//    “posts_tag”: (string[]) – 게시글 태그리스트
//    “comment_count”: (int) – 댓글 개수
//    “heart_count” : (int) – 좋아요 개수
//    }]
