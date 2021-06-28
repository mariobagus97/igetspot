////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class Favorite {
    static let KEY_USERNAME = "username"
    static let KEY_USER_ID = "user_id"
    static let KEY_PROVINCE = "province"
    static let KEY_ZIPCODE = "zipcode"
    static let KEY_PHONE = "phone"
    static let KEY_ADDRESS = "address"
    static let KEY_IMAGE_URL = "image_url"
    static let KEY_LAST_NAME = "last_name"
    static let KEY_MASTERNAME = "mastername"
    static let KEY_CITY = "city"
    static let KEY_LANGITUDE = "latitude"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_FIRST_NAME = "first_name"
    
    
    var username: String?
    var masterId: String?
    var province : String?
    var zipcode : String?
    var phone : String?
    var address : String?
    var masterImageUrl : String?
    var lastName: String?
    var masterName: String?
    var city: String?
    var longitude: String?
    var firstName: String?
    var latitude: String?
    var isFavorite: Bool = true
    
    static func with(json: JSON) -> Favorite {
        let data = Favorite()
        
        if json[KEY_USERNAME].exists(){
            data.username = json[KEY_USERNAME].stringValue
        }
        if json[KEY_USER_ID].exists(){
            data.masterId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_PROVINCE].exists(){
            data.province = json[KEY_PROVINCE].stringValue
        }
        if json[KEY_ZIPCODE].exists(){
            data.zipcode = json[KEY_ZIPCODE].stringValue
        }
        if json[KEY_PHONE].exists(){
            data.phone = json[KEY_PHONE].stringValue
        }
        if json[KEY_ADDRESS].exists(){
            data.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_IMAGE_URL].exists(){
            data.masterImageUrl = json[KEY_IMAGE_URL].stringValue
        }
        if json[KEY_LAST_NAME].exists(){
            data.lastName = json[KEY_LAST_NAME].stringValue
        }
        if json[KEY_MASTERNAME].exists(){
            data.masterName = json[KEY_MASTERNAME].stringValue
        }
        if json[KEY_CITY].exists(){
            data.city = json[KEY_CITY].stringValue
        }
        if json[KEY_LANGITUDE].exists(){
            data.latitude = json[KEY_LANGITUDE].stringValue
        }
        if json[KEY_FIRST_NAME].exists(){
            data.firstName = json[KEY_FIRST_NAME].stringValue
        }
        if json[KEY_LONGITUDE].exists(){
            data.longitude = json[KEY_LONGITUDE].stringValue
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [Favorite] {
        var favorites = [Favorite]()
        
        for json in jsons {
            let favorite = Favorite.with(json: json)
            favorites.append(favorite)
        }
        
        return favorites
    }
}
