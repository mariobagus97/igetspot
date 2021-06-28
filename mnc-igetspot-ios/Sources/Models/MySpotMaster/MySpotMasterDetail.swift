////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotMasterDetail {
    static let KEY_UUID = "user_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_IMAGE_URL = "master_background_image_url"
    static let KEY_MASTER_AVATAR_IMAGE_URL = "master_avatar_image_url"
    static let KEY_MASTER_BALANCE = "master_balance"
    static let KEY_MASTER_ORDER_REQUEST = "master_order_request"
    static let KEY_MASTER_BACKGROUND_IMAGE_URL = "master_background_image_url"
    static let KEY_ADDRESS = "master_address"

    var uuid: String?
    var masterName: String?
    var masterImageUrl : String?
    var address : String?
    var masterAvatarImageUrl: String?
    var masterBackgroundImageUrl: String?
    var masterBalance : Int = 0
    var masterOrderRequest : Int = 0
    
    static func with(json: JSON) -> MySpotMasterDetail {
        let data = MySpotMasterDetail()
        
        if json[KEY_UUID].exists(){
            data.uuid = json[KEY_UUID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_MASTER_IMAGE_URL].exists(){
            data.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        if json[KEY_MASTER_BALANCE].exists(){
            data.masterBalance = json[KEY_MASTER_BALANCE].intValue
        }
        if json[KEY_MASTER_ORDER_REQUEST].exists(){
            data.masterOrderRequest = json[KEY_MASTER_ORDER_REQUEST].intValue
        }
        if json[KEY_ADDRESS].exists(){
            data.address = json[KEY_ADDRESS].stringValue
        }
        if json[KEY_MASTER_AVATAR_IMAGE_URL].exists(){
            data.masterAvatarImageUrl = json[KEY_MASTER_AVATAR_IMAGE_URL].stringValue
        }
        if json[KEY_MASTER_BACKGROUND_IMAGE_URL].exists(){
            data.masterBackgroundImageUrl = json[KEY_MASTER_BACKGROUND_IMAGE_URL].stringValue
        }
        
        return data
    }
}
