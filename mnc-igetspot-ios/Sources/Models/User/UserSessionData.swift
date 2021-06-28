//
//  UserSessionData.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/21/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SwiftyJSON

class UserSessionData {
    
    static let KEY_UUID = "uuid"
    static let KEY_EMAIL = "email"
    static let KEY_ACCESS_TOKEN = "access_token"
    
    var uuid : String = ""
    var email : String = ""
    var accessToken : String = ""
    
    static func with(json: JSON) -> UserSessionData  {
        let user = UserSessionData()
        
        user.uuid = json[KEY_UUID].stringValue
        user.email = json[KEY_EMAIL].stringValue
        user.accessToken = json[KEY_ACCESS_TOKEN].stringValue
        
        return user
    }
    
}
