//
//  OrderResponseV2.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 22/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let orderResponseV2 = try? newJSONDecoder().decode(OrderResponseV2.self, from: jsonData)

import Foundation

// MARK: - OrderResponseV2
class OrderResponseV2: Codable {
    let paymentStatus, orderID: String?
    let masterList: [OrderHistoryV2]?

    enum CodingKeys: String, CodingKey {
        case paymentStatus = "payment_status"
        case orderID = "order_id"
        case masterList = "master_list"
    }

    init(paymentStatus: String?, orderID: String?, masterList: [OrderHistoryV2]?) {
        self.paymentStatus = paymentStatus
        self.orderID = orderID
        self.masterList = masterList
    }
}

// MARK: - MasterList
class OrderHistoryV2: Codable {
    let masterID, masterName, masterOf, orderID: String?
    let masterImageURL: String?
    let masterServicesList: [MasterServicesList]?

    enum CodingKeys: String, CodingKey {
        case masterID = "master_id"
        case masterName = "master_name"
        case masterOf = "master_of"
        case masterImageURL = "master_image_url"
        case masterServicesList = "master_services_list"
        case orderID = "order_id"

    }

    init(masterID: String?, masterName: String?, masterOf: String?, orderID: String?, masterImageURL: String?, masterServicesList: [MasterServicesList]?) {
        self.masterID = masterID
        self.masterName = masterName
        self.masterOf = masterOf
        self.masterImageURL = masterImageURL
        self.masterServicesList = masterServicesList
        self.orderID = orderID
    }
}

// MARK: - MasterServicesList
class MasterServicesList: Codable {
    let packageID: Int?
    let packageName, packagePrice: String?
    let packageImageURL: [String]?
    let orderDate, orderStatus, orderStatusString: String?

    enum CodingKeys: String, CodingKey {
        case packageID = "package_id"
        case packageName = "package_name"
        case packagePrice = "package_price"
        case packageImageURL = "package_image_url"
        case orderDate = "order_date"
        case orderStatus = "order_status"
        case orderStatusString = "order_status_string"
    }

    init(packageID: Int?, packageName: String?, packagePrice: String?, packageImageURL: [String]?, orderDate: String?, orderStatus: String?, orderStatusString: String?) {
        self.packageID = packageID
        self.packageName = packageName
        self.packagePrice = packagePrice
        self.packageImageURL = packageImageURL
        self.orderDate = orderDate
        self.orderStatus = orderStatus
        self.orderStatusString = orderStatusString
    }
}
