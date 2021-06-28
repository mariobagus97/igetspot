////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class PackageDetail {
    static let KEY_UUID = "master_id"
    static let KEY_FIRST_NAME = "firstname"
    static let KEY_LAST_NAME = "lastname"
    static let KEY_MASTER_NAME = "mastername"
    static let KEY_MASTER_NAME_DASH = "master_name"
    static let KEY_USER_NAME = "username"
    static let KEY_MASTERIMAGE = "image_url"
    static let KEY_RATING = "rating"
    static let KEY_REVIEW_NUMBER = "review"
    static let KEY_ABOUT = "about"
    static let KEY_ADDRESS = "address"
    static let KEY_COUNTRY = "country"
    static let KEY_CITY = "city"
    static let KEY_PROVINCE = "province"
    static let KEY_LATITUDE = "latitude"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_PHONE = "phone"
    static let KEY_DETAIL_BUILDING = "detail_building"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_PORTOFOLIO = "package_portfolio"
    static let KEY_PACKAGE_IMAGES = "package_images"
    static let KEY_PRICE = "price"
    static let KEY_FAVORITE = "favorite"
    static let KEY_WISHLIST = "wishlist"
    static let KEY_DURATION = "duration"
    static let KEY_USERID = "user_id"
    
    var masterId : String?
    var firtName : String?
    var lastName : String?
    var masterName : String?
    var masterUserName : String?
    var profileImageUrl : String?
    var rating : String?
    var totalReview : String?
    var about : String?
    var address : String?
    var country : String?
    var city : String?
    var province : String?
    var latitude : Double?
    var longitude : Double?
    var phone : String?
    var detailBuilding : String?
    var packageName : String?
    var packagePortofolioImages : [String]?
    var price : String?
    var duration : String?
    var isFavorite: Bool = false
    var isWishlist: Bool = false
    
    static func with(json: JSON) -> PackageDetail {
        let data = PackageDetail()
        
        if json[KEY_UUID].exists(){
            data.masterId = json[KEY_UUID].stringValue
        }
        
        if json[KEY_MASTERIMAGE].exists(){
            data.profileImageUrl = json[KEY_MASTERIMAGE].stringValue
        }
        
        if json[KEY_USERID].exists(){
            data.masterId = json[KEY_USERID].stringValue
        }
        
        if json[KEY_FIRST_NAME].exists(){
            data.firtName = json[KEY_FIRST_NAME].stringValue
        }
        if json[KEY_LAST_NAME].exists(){
            data.lastName = json[KEY_LAST_NAME].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_MASTER_NAME_DASH].exists(){
            data.masterName = json[KEY_MASTER_NAME_DASH].stringValue
        }
        if json[KEY_USER_NAME].exists(){
            data.masterUserName = json[KEY_USER_NAME].stringValue
        }
        if json[KEY_PACKAGE_IMAGES].exists(){
            data.packagePortofolioImages = json[KEY_PACKAGE_IMAGES].arrayValue.map { $0.stringValue}
        }
        if json[KEY_RATING].exists(){
            data.rating = json[KEY_RATING].stringValue
        }
        if json[KEY_REVIEW_NUMBER].exists(){
            data.totalReview = json[KEY_REVIEW_NUMBER].stringValue
        }
        if json[KEY_ABOUT].exists(){
            data.about = json[KEY_ABOUT].stringValue
        }
        if json[KEY_ADDRESS].exists(){
            data.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_COUNTRY].exists(){
            data.country = json[KEY_COUNTRY].stringValue
        }
        if json[KEY_CITY].exists(){
            data.city = json[KEY_CITY].stringValue
        }
        if json[KEY_PROVINCE].exists(){
            data.province = json[KEY_PROVINCE].stringValue
        }
        if json[KEY_LONGITUDE].exists(){
            data.longitude = json[KEY_LONGITUDE].doubleValue
        }
        if json[KEY_LATITUDE].exists(){
            data.latitude = json[KEY_LATITUDE].doubleValue
        }
        if json[KEY_PHONE].exists(){
            data.phone = json[KEY_PHONE].stringValue
        }
        if json[KEY_DETAIL_BUILDING].exists(){
            data.detailBuilding = json[KEY_DETAIL_BUILDING].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_PACKAGE_PORTOFOLIO].exists(){
            data.packagePortofolioImages = json[KEY_PACKAGE_PORTOFOLIO].arrayValue.map { $0.stringValue}
        }
        if json[KEY_PRICE].exists(){
            data.price = json[KEY_PRICE].stringValue
        }
        if json[KEY_DURATION].exists(){
            data.duration = json[KEY_DURATION].stringValue
        }
        if json[KEY_FAVORITE].exists(){
            data.isFavorite = json[KEY_FAVORITE].boolValue
        }
        if json[KEY_WISHLIST].exists(){
            data.isWishlist = json[KEY_WISHLIST].boolValue
        }
        
        return data
    }
}
