//
//  MySpotOrderRequestDetail.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 25/03/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import SwiftyJSON

class MySpotOrderRequestDetail {
    static let KEY_PACKAGE_PRICE = "package_price"
    static let KEY_ORDER_ID = "order_id"
    static let KEY_ORDER_LONGITUDE_LOCATION = "order_longitude_location"
    static let KEY_ORDER_LATITUDE_LOCATION = "order_latitude_location"
    static let KEY_ORDER_TIME_STRING = "order_time_string"
    static let KEY_ORDER_TIME = "order_time"
    static let KEY_PACKAGE_ID = "package_id"
    static let KEY_PACKAGE_NAME = "package_name"
    static let KEY_USER_NAME = "user_name"
    static let KEY_USER_FIRST_LAST_NAME = "user_first_last_name"
    static let KEY_ORDER_ADDRESS = "order_address"
    static let KEY_USER_EMAIL = "user_email"
    static let KEY_ORDER_NOTES = "order_notes"
    static let KEY_ORDER_DATE = "order_date"
    static let KEY_PACKAGE_IMAGE_URL = "package_image_url"
    static let KEY_USER_ID = "user_id"
    static let KEY_ORDER_STATUS = "order_status"
    static let KEY_ORDER_DATE_STRING = "order_date_string"
    static let KEY_USER_IMAGE_URL = "user_image_url"
    
    var packagePrice: String?
    var orderId: String?
    var orderLatitude: Double?
    var orderLongitude: Double?
    var orderTimeString: String?
    var orderTime: String?
    var packageId: String?
    var packageName: String?
    var userName: String?
    var userFirstLastName: String?
    var orderAddress: String?
    var userEmail: String?
    var orderNotes: String?
    var orderDate: String?
    var packageImageUrl: String?
    var userId: String?
    var orderStatus: String?
    var orderDateString: String?
    var userImageUrl: String?
    
    static func with(json: JSON) -> MySpotOrderRequestDetail {
        
        let orderDetail = MySpotOrderRequestDetail()
        
        if (json[KEY_PACKAGE_PRICE].exists()) {
            orderDetail.packagePrice = json[KEY_PACKAGE_PRICE].stringValue
        }
        if (json[KEY_ORDER_ID].exists()) {
            orderDetail.orderId = json[KEY_ORDER_ID].stringValue
        }
        if (json[KEY_ORDER_LONGITUDE_LOCATION].exists()) {
            orderDetail.orderLongitude = json[KEY_ORDER_LONGITUDE_LOCATION].doubleValue
        }
        if (json[KEY_ORDER_LATITUDE_LOCATION].exists()) {
            orderDetail.orderLatitude = json[KEY_ORDER_LATITUDE_LOCATION].doubleValue
        }
        if (json[KEY_ORDER_TIME_STRING].exists()) {
            orderDetail.orderTimeString = json[KEY_ORDER_TIME_STRING].stringValue
        }
        if (json[KEY_ORDER_TIME].exists()) {
            orderDetail.orderTime = json[KEY_ORDER_TIME].stringValue
        }
        if (json[KEY_PACKAGE_ID].exists()) {
            orderDetail.packageId = json[KEY_PACKAGE_ID].stringValue
        }
        if (json[KEY_PACKAGE_NAME].exists()) {
            orderDetail.packageName = json[KEY_PACKAGE_NAME].stringValue
        }
        if (json[KEY_USER_NAME].exists()) {
            orderDetail.userName = json[KEY_USER_NAME].stringValue
        }
        if (json[KEY_USER_FIRST_LAST_NAME].exists()) {
            orderDetail.userFirstLastName = json[KEY_USER_FIRST_LAST_NAME].stringValue
        }
        if (json[KEY_ORDER_ADDRESS].exists()) {
            orderDetail.orderAddress = json[KEY_ORDER_ADDRESS].stringValue
        }
        if (json[KEY_USER_EMAIL].exists()) {
            orderDetail.userEmail = json[KEY_USER_EMAIL].stringValue
        }
        if (json[KEY_ORDER_NOTES].exists()) {
            orderDetail.orderNotes = json[KEY_ORDER_NOTES].stringValue
        }
        if (json[KEY_ORDER_DATE].exists()) {
            orderDetail.orderDate = json[KEY_ORDER_DATE].stringValue
        }
        if (json[KEY_PACKAGE_IMAGE_URL].exists()) {
            orderDetail.packageImageUrl = json[KEY_PACKAGE_IMAGE_URL].stringValue
        }
        if (json[KEY_USER_ID].exists()) {
            orderDetail.userId = json[KEY_USER_ID].stringValue
        }
        if (json[KEY_ORDER_STATUS].exists()) {
            orderDetail.orderStatus = json[KEY_ORDER_STATUS].stringValue
        }
        if (json[KEY_ORDER_DATE_STRING].exists()) {
            orderDetail.orderDateString = json[KEY_ORDER_DATE_STRING].stringValue
        }
        if (json[KEY_USER_IMAGE_URL].exists()) {
            orderDetail.userImageUrl = json[KEY_USER_IMAGE_URL].stringValue
        }
        
        return orderDetail
    }
}
