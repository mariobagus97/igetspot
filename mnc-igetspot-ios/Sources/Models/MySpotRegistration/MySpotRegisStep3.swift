//
//  MySpotLastRegistration.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/28/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftyJSON

class MySpotRegisStep3 {
    
    static let KEY_ID_CARD = "idcard_number"
    static let KEY_PHOTO_ID = "photo_idcard"
    static let KEY_SELFIE_ID = "user_photo"
    static let KEY_ACCEPT_TERM = "accept_term"
    
    var idCard : String?
    var photoId : UIImage?
    var selfieId : UIImage?
    var acceptTerm : String?
    
    
    static func with(json: JSON) -> MySpotRegisStep3 {
        let registrationData = MySpotRegisStep3()
        
        if json[KEY_ID_CARD].exists(){
            registrationData.idCard = json[KEY_ID_CARD].stringValue
        }
        if json[KEY_ACCEPT_TERM].exists(){
            registrationData.acceptTerm = json[KEY_ACCEPT_TERM].stringValue
        }
        
        return registrationData
    }
    
}
