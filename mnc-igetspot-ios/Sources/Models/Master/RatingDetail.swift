////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class RatingDetail {
    static let KEY_MASTER_ID = "master_id"
    static let KEY_TOTAL_REVIEW = "total_review"
    static let KEY_AVERAGE_RATING = "average_rating"
    static let KEY_SERVICE_QUALITY_RATING = "service_quality_rating"
    static let KEY_TIMELINESS_RATING = "timeless_rating"
    static let KEY_QUALITY_RATING = "quality_rating"
    static let KEY_REVIEW_LIST = "review_list"
    
    var masterId : String?
    var totalReview: String?
    var averageRating: Double?
    var serviceQualityRating : Double?
    var timelinessRating : Double?
    var qualityRating : Double?
    var reviewList : [ReviewList]?
    
    static func with(json: JSON) -> RatingDetail {
        let ratingDetail = RatingDetail()
        
        if json[KEY_MASTER_ID].exists(){
            ratingDetail.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_TOTAL_REVIEW].exists(){
            ratingDetail.totalReview = json[KEY_TOTAL_REVIEW].stringValue
        }
        if json[KEY_AVERAGE_RATING].exists(){
            ratingDetail.averageRating = json[KEY_AVERAGE_RATING].doubleValue
        }
        if json[KEY_SERVICE_QUALITY_RATING].exists(){
            ratingDetail.serviceQualityRating = json[KEY_SERVICE_QUALITY_RATING].doubleValue
        }
        if json[KEY_TIMELINESS_RATING].exists(){
            ratingDetail.timelinessRating = json[KEY_TIMELINESS_RATING].doubleValue
        }
        if json[KEY_QUALITY_RATING].exists(){
            ratingDetail.qualityRating = json[KEY_QUALITY_RATING].doubleValue
        }
        if json[KEY_REVIEW_LIST].exists(){
            ratingDetail.reviewList = ReviewList.with(jsons: json[KEY_REVIEW_LIST].arrayValue)
        }
        
        return ratingDetail
    }
}
