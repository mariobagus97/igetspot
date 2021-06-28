//
//  BlogComment.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//


import SwiftyJSON
import Foundation

class BlogComment {
    
    static let KEY_REPLY_ID = "id"
    static let KEY_COMMENT_ID = "comment_id"
    static let KEY_COMMENT = "comment"
    static let KEY_COMMENT_SUBJECT = "comment_subject"
    static let KEY_DATE = "date"
    static let KEY_BLOG_ID = "blog_id"
    static let KEY_USER_ID = "uuid"
    static let KEY_USER_NAME = "username"
    
    var replyId : String?
    var commentId : String?
    var comment : String?
    var commentSubject : String?
    var date : String?
    var blogId : String?
    var userId : String?
    var userName : String?
    
    static func with(json: JSON) -> BlogComment {
        
        //        print("json blogdetail \(json.rawString())")
        
        let data = BlogComment()
        
        if json[KEY_REPLY_ID].exists(){
            data.replyId = json[KEY_REPLY_ID].stringValue
        }
        if json[KEY_COMMENT_ID].exists(){
            data.commentId = json[KEY_COMMENT_ID].stringValue
        }
        if json[KEY_COMMENT].exists(){
            data.comment = json[KEY_COMMENT].stringValue
        }
        if json[KEY_COMMENT_SUBJECT].exists(){
            data.commentSubject = json[KEY_COMMENT_SUBJECT].stringValue
        }
        if json[KEY_DATE].exists(){
            data.date = json[KEY_DATE].stringValue
        }
        if json[KEY_BLOG_ID].exists(){
            data.blogId = json[KEY_BLOG_ID].stringValue
        }
        if json[KEY_USER_ID].exists(){
            data.userId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_USER_NAME].exists(){
            data.userName = json[KEY_USER_NAME].stringValue
        }
        
        return data
    }
    
    
    static func with(jsons: [JSON]) -> [BlogComment] {
        var list = [BlogComment]()
        
        for json in jsons {
            let data = BlogComment.with(json: json)
            list.append(data)
        }
        
        return list
    }
    
}

