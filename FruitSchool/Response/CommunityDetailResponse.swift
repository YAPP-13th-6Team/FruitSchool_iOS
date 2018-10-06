//
//  CommunityDetailResponse.swift
//  FruitSchool
//
//  Created by 박주현 on 07/10/2018.
//  Copyright © 2018 YAPP. All rights reserved.
//

import Foundation

struct CommunityDetailResponse: Codable {
    struct Data: Codable {
        struct AuthorInfo: Codable {
            let id: String
            let userId: String
            let grade: String
            let nickname: String
            let profileImage: String
            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case userId, grade, nickname, profileImage
            }
        }
        let id: String
        let createdAt: Date
        let likes: Int
        let postImage: [String]
        let commentCount: Int
        let content: String
        let authorInfo: [AuthorInfo]
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case createdAt, likes, content, postImage, commentCount, authorInfo
        }
    }
    let message: String
    let data: [Data]
}

//{
//    “msg”: ” Success post ${user_id} posts ”
//    “data”: [{
//    "_id": (string) – 글 id,
//    "createdAt": (Date) – 글 게시한 날짜 ex) ”2018-10-06T08:45:04:000Z” ,
//    "likes": (int) – 게시글 좋아요 수,
//    "post_image": (string[])- 게시글 이미지,
//    "comment_count": (int) – 댓글 개수 ,
//    "content": (string) – 게시글 내용,
//    "author_info": (string[]) [
//    {
//    "_id": (string) - 게시자 id,
//    "user_id": (string)
//    "grade": (string) – 게시자 등급, array
//    "nickname": (string) - 게시자 닉네임 array
//    "profile_image": (string) - 게시자 프로필 사진 링크
//    }
//    ], - 게시자 정보(array임 주의)
//
//    }]
//}
