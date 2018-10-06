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
        struct AuthorInfo: Codable {
            let id: String
            let grade: Int
            let userId: String
            let nickname: String
            let profileImage: String
            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case userId, grade, nickname, profileImage
            }
        }
        let id: String
        let createdAt: String
        let likes: Int
        let postImage: [String]
        let commentCount: Int
        let content: String
        let authorInfo: [AuthorInfo]
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case createdAt, likes, postImage, commentCount, content, authorInfo
        }
    }
    let message: String
    let data: [Data]
}

//{
//    “msg”: ” Success get posts list sorted by ${sort}”
//    “data”: [{
//    “_id” (String) – 게시글 id
//    “createdAt” (Date) – 글 게시 날짜
//    “likes”: (int) – 게시글 좋아요 수
//    “post_image”: (String[]) – 게시글 사진 리스트
//    “comment_count”: (int) – 댓글 개수
//    “content”: (String) – 게시글 내용
//    "author_info": (string[]) [
//    {
//    "_id": (string) - 게시자 id,
//    "grade": (string) – 게시자 등급
//    "user_id": (string) – 게시자 카카오톡 id,
//    "nickname": (string) - 게시자 닉네임
//    "profile_image": (string) - 게시자 프로필 사진 링크
//    }
//    ], - 게시자 정보(array임 주의)
//
//    }]
//}
