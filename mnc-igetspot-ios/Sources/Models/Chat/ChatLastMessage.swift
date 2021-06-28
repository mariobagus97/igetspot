////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatLastMessage {
    
    static let KEY_MESSAGE_ID = "message_id"
    static let KEY_CHANNEL_URL = "channel_url"
    static let KEY_MESSAGE = "message"
    static let KEY_CREATED_AT = "created_at"
    static let KEY_TYPE = "type"
    
    var messageId:String?
    var channelUrl: String?
    var message: String?
    var createdAt: Double?
    var type: String?
    
    static func with(json: JSON) -> ChatLastMessage {
        
        let chatLastMessage = ChatLastMessage()
        
        if (json[KEY_MESSAGE_ID].exists()) {
            chatLastMessage.messageId = json[KEY_MESSAGE_ID].stringValue
        }
        if (json[KEY_CHANNEL_URL].exists()) {
            chatLastMessage.channelUrl = json[KEY_CHANNEL_URL].stringValue
        }
        if (json[KEY_MESSAGE].exists()) {
            chatLastMessage.message = json[KEY_MESSAGE].stringValue
        }
        if (json[KEY_CREATED_AT].exists()) {
            chatLastMessage.createdAt = json[KEY_CREATED_AT].doubleValue
        }
        if (json[KEY_TYPE].exists()){
            chatLastMessage.type = json[KEY_TYPE].stringValue
        }
        
        return chatLastMessage
    }
    
}
