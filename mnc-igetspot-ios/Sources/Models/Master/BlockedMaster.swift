//
//  BlockedMaster.swift
//  mnc-igetspot-ios
//
//  Created by Handi Deyana on 25/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

class BlockedMaster: Codable {
    let userID, username, mastername: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case username, mastername
    }

    init(userID: String?, username: String?, mastername: String?) {
        self.userID = userID
        self.username = username
        self.mastername = mastername
    }
}
