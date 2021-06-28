////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import SwiftyJSON

class OrderDetail {
    
    static let KEY_USER_EMAIL = "email"
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_PACKAGE_DURATION = "package_duration"
    static let KEY_MASTER_ID = "master_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_MASTER_IMAGE = "master_image"
    static let KEY_ORDER_LOCATION = "order_location"
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_ORDER_NOTES = "order_notes"
    static let KEY_USER_PHONE = "phone"
    static let KEY_USER_ID = "user_id"
    static let KEY_ORDER_DATE = "order_date"
    static let KEY_ORDER_ADDRESS = "order_address"
    static let KEY_USER_FULLNAME = "fullname"
    static let KEY_MASTER_NAME = "master_name"
    static let KEY_ORDER_TIME = "order_time"
    
    
    var userEmail: String?
    var packagePrice: String?
    var packageDuration: String?
    var masterId: String?
    var packageName: String?
    var masterImageurl: String?
    var orderLocation: String?
    var packageId: String?
    var orderNotes: String?
    var userPhone: String?
    var userId: String?
    var orderDate: String?
    var orderAddress: String?
    var userFullName: String?
    var masterName: String?
    var orderTime: String?
    
    static func with(json: JSON) -> OrderDetail {
        let data = OrderDetail()
        
        if json[KEY_USER_EMAIL].exists(){
            data.userEmail = json[KEY_USER_EMAIL].stringValue
        }
        if json[KEY_PACKAGE_PRICE].exists(){
            data.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if json[KEY_MASTER_ID].exists(){
            data.masterId = json[KEY_MASTER_ID].stringValue
        }
        if json[KEY_PACKAGE_NAME].exists(){
            data.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if json[KEY_MASTER_IMAGE].exists(){
            data.masterImageurl = json[KEY_MASTER_IMAGE].stringValue
        }
        if json[KEY_ORDER_LOCATION].exists(){
            data.orderLocation = json[KEY_ORDER_LOCATION].stringValue
        }
        if json[KEY_PACKAGE_ID].exists(){
            data.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if json[KEY_ORDER_NOTES].exists(){
            data.orderNotes = json[KEY_ORDER_NOTES].stringValue
        }
        if json[KEY_USER_PHONE].exists(){
            data.userPhone = json[KEY_USER_PHONE].stringValue
        }
        if json[KEY_USER_ID].exists(){
            data.userId = json[KEY_USER_ID].stringValue
        }
        if json[KEY_ORDER_DATE].exists(){
            data.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        if json[KEY_ORDER_ADDRESS].exists(){
            data.orderAddress = json[KEY_ORDER_ADDRESS].stringValue
        }
        if json[KEY_USER_FULLNAME].exists(){
            data.userFullName = json[KEY_USER_FULLNAME].stringValue
        }
        if json[KEY_MASTER_NAME].exists(){
            data.masterName = json[KEY_MASTER_NAME].stringValue
        }
        if json[KEY_ORDER_TIME].exists(){
            data.orderTime = json[KEY_ORDER_TIME].stringValue
        }
        if json[KEY_PACKAGE_DURATION].exists(){
            data.packageDuration = json[KEY_PACKAGE_DURATION].stringValue
        }
        
        return data
    }
}
