//
//  MySpotServiceDetail.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 29/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

class ServiceDetail: Codable {
    let packageID: Int?
    let packageName: String?

    enum CodingKeys: String, CodingKey {
        case packageID = "subcategory_id"
        case packageName = "subcategory_name"
        
    }

    init(packageID: Int?, packageName: String?) {
        self.packageID = packageID
        self.packageName = packageName
    }
}
