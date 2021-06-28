////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MasterDetail {
    static let KEY_MASTER_NAME = "mastername"
    static let KEY_USER_NAME = "username"
    static let KEY_ABOUT = "about"
    static let KEY_LANGITUDE = "latitude"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_PROVINCE = "province"
    static let KEY_ADDRESS = "address"
    static let KEY_UUID = "user_id"
    static let KEY_ZIPCODE = "zipcode"
    static let KEY_RATING = "rating"
    static let KEY_PROFILE_PICTURE = "profile_picture"
    static let KEY_DETAIL_BUILDING = "detail_building"
    static let KEY_CITY = "city"
    static let KEY_COUNTRY = "country"
    static let KEY_FAVORITE = "favorite"
    static let KEY_SLUG = "username_slug"
    
    var masterId: String?
    var masterName: String?
    var masterUserName: String?
    var about : String?
    var latitude : String?
    var province : String?
    var address : String?
    var zipcode : String?
    var rating: Double?
    var profilePictureUrl: String?
    var detailBuilding: String?
    var city: String?
    var country: String?
    var longitude: String?
    var isFavorite : Bool = false
    var slug: String?
    
    static func with(json: JSON) -> MasterDetail {
        let data = MasterDetail()
        
        if json[KEY_UUID].exists(){
            data.masterId = json[KEY_UUID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_USER_NAME].exists(){
            data.masterUserName = json[KEY_USER_NAME].stringValue
        }
        if json[KEY_ABOUT].exists(){
            data.about = json[KEY_ABOUT].stringValue
        }
        if json[KEY_LANGITUDE].exists(){
            data.latitude = json[KEY_LANGITUDE].stringValue
        }
        if json[KEY_LONGITUDE].exists(){
            data.longitude = json[KEY_LONGITUDE].stringValue
        }
        if json[KEY_PROVINCE].exists(){
            data.province = json[KEY_PROVINCE].stringValue
        }
        if json[KEY_ADDRESS].exists(){
            data.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_ZIPCODE].exists(){
            data.zipcode = json[KEY_ZIPCODE].stringValue
        }
        if json[KEY_PROFILE_PICTURE].exists(){
            data.profilePictureUrl = json[KEY_PROFILE_PICTURE].stringValue
        }
        if json[KEY_DETAIL_BUILDING].exists(){
            data.detailBuilding = json[KEY_DETAIL_BUILDING].stringValue
        }
        if json[KEY_CITY].exists(){
            data.city = json[KEY_CITY].stringValue
        }
        if json[KEY_COUNTRY].exists(){
            data.country = json[KEY_COUNTRY].stringValue
        }
        if json[KEY_ZIPCODE].exists(){
            data.zipcode = json[KEY_ZIPCODE].stringValue
        }
        if json[KEY_FAVORITE].exists(){
            data.isFavorite = json[KEY_FAVORITE].boolValue
        }
        if json[KEY_RATING].exists(){
            data.rating = json[KEY_RATING].doubleValue
        }
        
        if json[KEY_SLUG].exists(){
            data.slug = json[KEY_SLUG].stringValue
        }
        
        return data
    }
}
