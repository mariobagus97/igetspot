//
//  ReviewList.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReviewList {
    
    static let KEY_RATE = "rate"
    static let KEY_USERNAME = "user_name"
    static let KEY_USER_HISTORY = "user_history"
    static let KEY_REVIEW_DATE = "review_date"
    static let KEY_REVIEW = "review"
    static let KEY_IMAGE_URL = "user_avatar"
    
    var rate : Double?
    var userName : String?
    var userHistory : String?
    var reviewDate : String?
    var review : String?
    var imageUrl : String?
    
    static func with(json: JSON) -> ReviewList {
        
        let reviewList = ReviewList()
        
        if json[KEY_RATE].exists() {
            reviewList.rate = json[KEY_RATE].doubleValue
        }
        if json[KEY_USERNAME].exists() {
            reviewList.userName = json[KEY_USERNAME].stringValue
        }
        if json[KEY_USER_HISTORY].exists() {
            reviewList.userHistory = json[KEY_USER_HISTORY].stringValue
        }
        if json[KEY_REVIEW_DATE].exists() {
            reviewList.reviewDate = json[KEY_REVIEW_DATE].stringValue
        }
        if json[KEY_REVIEW].exists() {
            reviewList.review = json[KEY_REVIEW].stringValue
        }
        if json[KEY_IMAGE_URL].exists() {
            reviewList.imageUrl = json[KEY_IMAGE_URL].stringValue
        }
        return reviewList
    }
    
    
    static func with(jsons: [JSON]) -> [ReviewList] {
        var reviewArray = [ReviewList]()
        
        for json in jsons {
            let data = ReviewList.with(json: json)
            reviewArray.append(data)
        }
        return reviewArray
    }
}
