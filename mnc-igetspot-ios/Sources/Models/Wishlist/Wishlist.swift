////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class Wishlist {
    
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    static let KEY_PRICE = "price"
    static let KEY_MASTER_ID = "master_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_MASTER_IMAGE_URL = "master_image_url"
    
    var packageId: String?
    var packageName: String?
    var packageImageArray: [String]?
    var price: String?
    var masterId: String?
    var masterName:String?
    var masterImageUrl:String?
    var isWishlist:Bool = true
    
    static func with(jsons: [JSON]) -> [Wishlist] {
        var wishlistArray = [Wishlist]()
        
        for json in jsons {
            let wishlist = Wishlist.with(json: json)
            wishlistArray.append(wishlist)
        }
        return wishlistArray
    }
    
    static func with(json: JSON) -> Wishlist {
        let data = Wishlist()
        
        if json[KEY_PACKAGE_ID].exists(){
            data.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_PACKAGE_IMAGE_URL].exists(){
            data.packageImageArray = json[KEY_PACKAGE_IMAGE_URL].arrayValue.map { $0.stringValue}
        }
        if json[KEY_PRICE].exists(){
            data.price = json[KEY_PRICE].stringValue
        }
        if json[KEY_MASTER_ID].exists(){
            data.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_MASTER_IMAGE_URL].exists(){
            data.masterImageUrl = json[KEY_MASTER_IMAGE_URL].stringValue
        }
        
        return data
    }
}
