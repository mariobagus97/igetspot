////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit

enum MessageStatus:Int {
    case sending
    case sent
    case received
    case read
    case failed
}

enum IGSMessageType:String {
    case image = "image"
    case text = "text"
    case audio = "audio"
    case file = "file"
    case unknown = "unknown"
}

private struct CoordinateItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var stringURL: String
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    var isLoaded: Bool
    
    init(imageUrl: String) {
        self.url = URL(string: imageUrl)
        self.stringURL = imageUrl
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        self.isLoaded = false
    }
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        self.isLoaded = false
        self.stringURL = ""
    }
}

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}

internal struct ChatMessage: MessageType {
    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: SenderType, messageId: String, sendDate: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sendDate
    }
    
    init(custom: Any?, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(text: String, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(attributedText: NSAttributedString, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(image: UIImage, sender: SenderType, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(imageUrl: String, sender: SenderType, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(imageUrl: imageUrl)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(thumbnail: UIImage, sender: SenderType, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(location: CLLocation, sender: SenderType, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, sendDate: date)
    }
    
    init(emoji: String, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, sendDate: date)
    }
    
}
