////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatMember {
    
    static let KEY_USER_ID = "user_id"
    static let KEY_NICKNAME = "nickname"
    static let KEY_PROFILE_URL = "profile_url"
    static let KEY_IS_ONLINE = "is_online"
    static let KEY_LAST_SEEN_AT = "last_seen_at"
    static let KEY_PHONE_NUMBER = "phone_number"
    
    var userId: String?
    var nickName: String?
    var profileUrl: String?
    var isOnline: Bool?
    var phoneNumber: String?
    var lastSeenAt: Double?
    
    static func with(json: JSON) -> ChatMember {
        
        let chatMember = ChatMember()
        
        if (json[KEY_USER_ID].exists()) {
            chatMember.userId = json[KEY_USER_ID].stringValue
        }
        if (json[KEY_NICKNAME].exists()) {
            chatMember.nickName = json[KEY_NICKNAME].stringValue
        }
        if (json[KEY_PROFILE_URL].exists()) {
            chatMember.profileUrl = json[KEY_PROFILE_URL].stringValue
        }
        if (json[KEY_IS_ONLINE].exists()) {
            chatMember.isOnline = json[KEY_IS_ONLINE].boolValue
        }
        if (json[KEY_LAST_SEEN_AT].exists()) {
            chatMember.lastSeenAt = json[KEY_LAST_SEEN_AT].doubleValue
        }
        if (json[KEY_PHONE_NUMBER].exists()) {
            chatMember.phoneNumber = json[KEY_PHONE_NUMBER].stringValue
        }
        return chatMember
    }
    
    static func with(jsons: [JSON]) -> [ChatMember] {
        var chatMemberArray = [ChatMember]()
        
        for json in jsons {
            let chatMember = ChatMember.with(json: json)
            chatMemberArray.append(chatMember)
        }
        
        return chatMemberArray
    }
}
