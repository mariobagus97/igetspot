//
//  Master.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/5/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Master {
    
    var id : String?
    var masterName: String?
    var profilePicture: String?
    var background: String?
    var about : String?
    var rating: Double?
    var reviewFrom : String?
    var serviceQualityrate : Double?
    var timelinessRate : Double?
    var qualityRate : Double?
    var address : String?
    var langitude : String?
    var longitude : String?
    var detailBuilding : String?
    var country : String?
    var city : String?
    var province : String?
    var postCode : Int?
    
    var masterOf : String?
    var image : String?
    
    var masterId : String?
    
    static let TYPE_OF_THE_WEEK = 1
    
    static let KEY_ID = "id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_PROFILE_PICTURE = "profile_picture"
    static let KEY_BACKGROUND = "background"
    static let KEY_ABOUT = "about"
    static let KEY_RATING = "rating"
    static let KEY_REVIEW_FROM = "review_from"
    static let KEY_SERVICE_QUALITY_RATE = "service_quality_rate"
    static let KEY_TIMELINESS_RATE = "timeliness_rate"
    static let KEY_QUALITY_RATE = "quality_rate"
    static let KEY_ADDRESS = "address"
    static let KEY_LANGITUDE = "latitude"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_DETAIL_BUILDING = "detail_building"
    static let KEY_COUNTRY = "country"
    static let KEY_CITY = "city"
    static let KEY_PROVINCE = "province"
    static let KEY_POST_CODE = "post_code"
    
    
    static let KEY_MASTER_OF = "masterOf"
    static let KEY_IMAGE = "image"
    
    static let KEY_MASTER_ID = "master_id"
    
    
    static func with(json: JSON) -> Master {
        let master = Master()
        
        if json[KEY_ID].exists(){
            master.id = json[KEY_ID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            master.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_PROFILE_PICTURE].exists(){
            master.profilePicture = json[KEY_PROFILE_PICTURE].stringValue
        }
        if json[KEY_BACKGROUND].exists(){
            master.background = json[KEY_BACKGROUND].stringValue
        }
        if json[KEY_ABOUT].exists(){
            master.about = json[KEY_ABOUT].stringValue
        }
        if json[KEY_RATING].exists(){
            master.rating = json[KEY_RATING].doubleValue
        }
        if json[KEY_REVIEW_FROM].exists(){
            master.reviewFrom = json[KEY_REVIEW_FROM].stringValue
        }
        if json[KEY_SERVICE_QUALITY_RATE].exists(){
            master.serviceQualityrate = json[KEY_SERVICE_QUALITY_RATE].doubleValue
        }
        if json[KEY_TIMELINESS_RATE].exists(){
            master.timelinessRate = json[KEY_TIMELINESS_RATE].doubleValue
        }
        if json[KEY_QUALITY_RATE].exists(){
            master.qualityRate = json[KEY_QUALITY_RATE].doubleValue
        }
        if json[KEY_ADDRESS].exists(){
            master.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_LANGITUDE].exists(){
            master.langitude = json[KEY_LANGITUDE].stringValue
        }
        if json[KEY_LONGITUDE].exists(){
            master.longitude = json[KEY_LONGITUDE].stringValue
        }
        if json[KEY_DETAIL_BUILDING].exists(){
            master.detailBuilding = json[KEY_DETAIL_BUILDING].stringValue
        }
        if json[KEY_COUNTRY].exists(){
            master.country = json[KEY_COUNTRY].stringValue
        }
        if json[KEY_CITY].exists(){
            master.city = json[KEY_CITY].stringValue
        }
        if json[KEY_PROVINCE].exists(){
            master.province = json[KEY_PROVINCE].stringValue
        }
        if json[KEY_POST_CODE].exists(){
            master.postCode = json[KEY_POST_CODE].intValue
        }
        if json[KEY_MASTER_ID].exists(){
            master.masterId = json[KEY_POST_CODE].stringValue
        }
        
        return master
    }
    
    
    static func with(type: Int? = 0,  jsons: [JSON]) -> [Master] {
        var masters = [Master]()
        
        if (type == TYPE_OF_THE_WEEK){
            for json in jsons {
                let master = Master.ofTheWeek(json: json)
                masters.append(master)
            }
        } else {
            for json in jsons {
                let master = Master.with(json: json)
                masters.append(master)
            }
        }
        
        return masters
    }
    
    static func ofTheWeek(json: JSON) -> Master {
        let master = Master()
        
        master.masterId = json[KEY_MASTER_ID].stringValue
        master.masterName = json[KEY_MASTER_NAME].stringValue
        master.masterOf = json[KEY_MASTER_OF].stringValue
        master.image = json[KEY_IMAGE].stringValue
        
        return master
        
    }
}
