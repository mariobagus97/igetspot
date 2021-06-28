////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecentChat {

    static let KEY_CHANNEL_URL = "channel_url"
    static let KEY_CREATED_AT = "created_at"
    static let KEY_UNREAD_MESSAGE_COUNT = "unread_message_count"
    static let KEY_MEMBERS = "members"
    static let KEY_LAST_MESSAGE = "last_message"
    
    var channelUrl: String?
    var createdAt: Double?
    var unreadMessageCount: Int?
    var member: ChatMember?
    var lastMessage: ChatLastMessage?
    
    static func with(json: JSON, currentUserId:String) -> RecentChat {
        
        let recentChat = RecentChat()
        
        if (json[KEY_CHANNEL_URL].exists()) {
            recentChat.channelUrl = json[KEY_CHANNEL_URL].stringValue
        }
        if (json[KEY_CREATED_AT].exists()) {
            recentChat.createdAt = json[KEY_CREATED_AT].doubleValue
        }
        if (json[KEY_UNREAD_MESSAGE_COUNT].exists()) {
            recentChat.unreadMessageCount = json[KEY_UNREAD_MESSAGE_COUNT].intValue
        }
        if (json[KEY_MEMBERS].exists()) {
            let memberArray = ChatMember.with(jsons:json[KEY_MEMBERS].arrayValue)
            for member in memberArray {
                if (member.userId != currentUserId) {
                    recentChat.member = member
                    break
                }
            }
        }
        if (json[KEY_LAST_MESSAGE].exists()) {
            recentChat.lastMessage = ChatLastMessage.with(json: json[KEY_LAST_MESSAGE])
        }
        
        return recentChat
    }
    
    static func with(jsons: [JSON], currentUserId:String) -> [RecentChat] {
        var recentChatArray = [RecentChat]()
        
        for json in jsons {
            let recentChat = RecentChat.with(json: json, currentUserId:currentUserId)
            recentChatArray.append(recentChat)
        }
        
        return recentChatArray
    }
}


