////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotPackageDetail {
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_DESCRIPTION = "package_description"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_AVATAR_URL = "master_avatar_url"
    static let KEY_MASTER_ID = "master_id"
    static let KEY_PACKAGE_PORTOFOLIO = "package_portfolio"
    static let KEY_MASTER_BACKGROUND_URL = "master_background_url"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_DURATION = "package_duration"
    
    var packageId : String?
    var masterImageUrl : String?
    var packageName : String?
    var packageDescription : String?
    var masterName : String?
    var masterAvatarUrl : String?
    var masterId : String?
    var packagePortofolios : [MySpotPackageImage]?
    var masterBackgroundUrl : String?
    var price : String?
    var packageDuration : String?
    
    static func with(json: JSON) -> MySpotPackageDetail {
        let data = MySpotPackageDetail()
        
        if json[KEY_PACKAGE_ID].exists(){
            data.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if json[KEY_MASTER_IMAGE_URL].exists(){
            data.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_PACKAGE_DESCRIPTION].exists(){
            data.packageDescription = json[KEY_PACKAGE_DESCRIPTION].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_MASTER_AVATAR_URL].exists(){
            data.masterAvatarUrl = json[KEY_MASTER_AVATAR_URL].stringValue
        }
        if json[KEY_MASTER_BACKGROUND_URL].exists(){
            data.masterBackgroundUrl = json[KEY_MASTER_BACKGROUND_URL].stringValue
        }
        if json[KEY_PACKAGE_PRICE].exists(){
            data.price = json[KEY_PACKAGE_PRICE].stringValue
        }
        if json[KEY_PACKAGE_DURATION].exists(){
            data.packageDuration = json[KEY_PACKAGE_DURATION].stringValue
        }
        if json[KEY_PACKAGE_PORTOFOLIO].exists(){
            let images = json[KEY_PACKAGE_PORTOFOLIO].arrayValue.map{$0.stringValue}
            var packs: [MySpotPackageImage] = []
            
            for item in images {
                let me = MySpotPackageImage()
                me.imageUrl = item
                packs.append(me)
            }
            
            data.packagePortofolios = packs
        }
    
        return data
    }
}
