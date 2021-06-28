////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class Package {
    static let KEY_DESCRIPTION = "description"
    static let KEY_REVIEW = "review"
    static let KEY_ID = "package_id"
    static let KEY_RATE = "rate"
    static let KEY_MASTER_ID = "master_id"
    static let KEY_LOCATION = "location"
    static let KEY_LONGITUDE = "longitude"
    static let KEY_LATITUDE = "latitude"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_PACKAGE_IMAGE = "package_image"
    static let KEY_PRICE = "price"
    static let KEY_IMAGE_ID = "image_id"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_ADDRESS = "address"
    static let KEY_COUNTRY = "country"
    static let KEY_CITY = "city"
    static let KEY_PROVINCE = "Province"
    
    var description : String?
    var totalReview : String?
    var packageId : String?
    var rate : String?
    var masterId : String?
    var masterName : String?
    var packageImageArray : [String]?
    var imageId : String?
    var price : String?
    var packageName : String?
    var location : String?
    var address : String?
    var country : String?
    var city : String?
    var province : String?
    var longitude : String?
    var latitude : String?
    
    static func with(json: JSON) -> Package {
        let data = Package()
        
        if json[KEY_ID].exists(){
            data.packageId = json[KEY_ID].stringValue
        }
        if json[KEY_MASTER_ID].exists(){
            data.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_PACKAGE_IMAGE].exists(){
            data.packageImageArray = json[KEY_PACKAGE_IMAGE].arrayValue.map { $0.stringValue}
        }
        if json[KEY_DESCRIPTION].exists(){
            data.description = json[KEY_DESCRIPTION].stringValue
        }
        if json[KEY_IMAGE_ID].exists(){
            data.imageId = json[KEY_IMAGE_ID].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_PRICE].exists(){
            data.price = json[KEY_PRICE].stringValue
        }
        if json[KEY_RATE].exists(){
            data.rate = json[KEY_RATE].stringValue
        }
        if json[KEY_REVIEW].exists(){
            data.totalReview = json[KEY_REVIEW].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_LOCATION].exists(){
            data.location = json[KEY_LOCATION].stringValue
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
            data.longitude = json[KEY_LONGITUDE].stringValue
        }
        if json[KEY_LATITUDE].exists(){
            data.latitude = json[KEY_LATITUDE].stringValue
        }
        
        return data
    }
    
    static func with(jsons: [JSON]) -> [Package] {
        var packageList = [Package]()
        
        for json in jsons {
            let package = Package.with(json: json)
            packageList.append(package)
        }
        return packageList
    }
}
