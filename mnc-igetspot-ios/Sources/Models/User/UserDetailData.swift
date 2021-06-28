//
//  UserSessionData.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SwiftyJSON

class UserDetailData {
    
    static let KEY_UUID = "uuid"
    static let KEY_EMAIL = "email"
    static let KEY_ACCESS_TOKEN = "access_token"
    
    static let KEY_ID = "id"
    static let KEY_USER_ID = "user_id"
    static let KEY_ROLES_ID = "roles_id"
    static let KEY_ID_NUMBER = "idNumber"
    static let KEY_USERNAME = "username"
    static let KEY_MASTERNAME = "mastername"
    static let KEY_FIRSTNAME = "firstname"
    static let KEY_LASTNAME = "lastname"
    static let KEY_PHONE = "phone"
    static let KEY_ADDRESS = "address"
    static let KEY_DETAIL_BUILDING = "detail_building"
    static let KEY_CITY = "city"
    static let KEY_PROVINCE = "province"
    static let KEY_COUNTRY = "country"
    static let KEY_ZIPCODE = "zipcode"
    static let KEY_LATITUDE = "latitude"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_GENDER = "gender"
    static let KEY_BIRTHDATE = "birthdate"
    static let KEY_IMAGE_URL = "image_url"
    static let KEY_BALANCE = "balance"
    static let KEY_BANK = "bank"
    
    static let KEY_DEVICE_ID = "deviceId"
    
    static let KEY_USER_LEVEL = "user_level"
    static let KEY_DETAIL_ADDRESS = "detail_address"
    static let KEY_JOB = "job"
    static let KEY_STATUS = "status"
    
    static let KEY_AVATAR = "avatar"
    static let KEY_BACKGROUND_PROFILE = "background_profile"
    
    static let thisDeviceId = 20
    
    static let TYPE_EMAIL : Int = 3
    static let TYPE_FB : Int = 1
    static let TYPE_GOOGLE : Int = 2

    
    var uuid : String = ""
    var email : String = ""
    var accessToken : String = ""
    
    var id : Int = -1
    var userId : String = ""
    var rolesId : Int?
    var idNumber : String = ""
    var username : String = ""
    var mastername : String = ""
    var firstname : String = ""
    var lastname: String = ""
    var phone : String = ""
    var address : String = ""
    var detail_bulding : String = ""
    var city : String = ""
    var province : String = ""
    var country : String = ""
    var zipcode : Int?
    var latitude : String = ""
    var longitude : String = ""
    var gender : String = ""
    var birthdate : String = ""
    var imageUrl : String = ""
    var balance : Int = 0
    var bank : String = ""
    
    var userLevel : String = ""
    var detailAddress : String = ""
    var job : String = ""
    var status : String = ""
    
    var avatar : String = ""
    var backgroundProfile : String = ""

    static func with(json: JSON) -> UserDetailData {
        let user = UserDetailData()
        
        if json[KEY_UUID].exists(){
            user.uuid = json[KEY_UUID].stringValue
        }
        if json[KEY_EMAIL].exists(){
            user.email = json[KEY_EMAIL].stringValue
        }
        if json[KEY_ACCESS_TOKEN].exists(){
            user.accessToken = json[KEY_ACCESS_TOKEN].stringValue
        }
        if json[KEY_ID].exists(){
            user.id = json[KEY_ID].intValue
        }
        if json[KEY_USER_ID].exists(){
            user.userId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_ROLES_ID].exists(){
            user.rolesId = json[KEY_ROLES_ID].intValue
        }
        if json[KEY_ID_NUMBER].exists(){
            user.idNumber = json[KEY_ID_NUMBER].stringValue
        }
        if json[KEY_USERNAME].exists(){
            user.username = json[KEY_USERNAME].stringValue
        }
        if json[KEY_MASTERNAME].exists(){
            user.mastername = json[KEY_MASTERNAME].stringValue
        }
        if json[KEY_FIRSTNAME].exists(){
            user.firstname = json[KEY_FIRSTNAME].stringValue
        }
        if json[KEY_LASTNAME].exists(){
            user.lastname = json[KEY_LASTNAME].stringValue
        }
        if json[KEY_PHONE].exists(){
            user.phone = json[KEY_PHONE].stringValue
        }
        if json[KEY_ADDRESS].exists(){
            user.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_DETAIL_BUILDING].exists(){
            user.detail_bulding = json[KEY_DETAIL_BUILDING].stringValue
        }
        if json[KEY_CITY].exists(){
            user.city = json[KEY_CITY].stringValue
        }
        if json[KEY_PROVINCE].exists(){
            user.province = json[KEY_PROVINCE].stringValue
        }
        if json[KEY_COUNTRY].exists(){
            user.country = json[KEY_COUNTRY].stringValue
        }
        if json[KEY_ZIPCODE].exists(){
            user.zipcode = json[KEY_ZIPCODE].intValue
        }
        if json[KEY_LATITUDE].exists(){
            user.latitude = json[KEY_LATITUDE].stringValue
        }
        if json[KEY_LONGITUDE].exists(){
            user.longitude = json[KEY_LONGITUDE].stringValue
        }
        if json[KEY_GENDER].exists(){
            user.gender = json[KEY_GENDER].stringValue
        }
        if json[KEY_BIRTHDATE].exists(){
            user.birthdate = json[KEY_BIRTHDATE].stringValue
        }
        if json[KEY_IMAGE_URL].exists(){
            user.imageUrl = json[KEY_IMAGE_URL].stringValue
        }
        if json[KEY_BALANCE].exists(){
            user.balance = json[KEY_BALANCE].intValue
        }
        if json[KEY_BANK].exists(){
            user.bank = json[KEY_BANK].stringValue
        }
        if json[KEY_USER_LEVEL].exists(){
            user.userLevel = json[KEY_USER_LEVEL].stringValue
        }
        if json[KEY_DETAIL_ADDRESS].exists(){
            user.bank = json[KEY_DETAIL_ADDRESS].stringValue
        }
        if json[KEY_AVATAR].exists(){
            user.avatar = json[KEY_AVATAR].stringValue
        }
        if json[KEY_BACKGROUND_PROFILE].exists(){
            user.backgroundProfile = json[KEY_BACKGROUND_PROFILE].stringValue
        }
        
        return user
    }
    
  
}
