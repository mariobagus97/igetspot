////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftDate

protocol RecentChatCellDelegate:class {
    func recentChatDidClicked(recentChat: RecentChat)
}

class RecentChatCell: MKTableViewCell {
    
    @IBOutlet weak var onlineStatusView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var totalUnreadLabel: UILabel!
    weak var delegate: RecentChatCellDelegate?
    var recentChat: RecentChat?
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorHeight.constant = 0.5
        onlineStatusView.setRounded()
        unreadView.setRounded()
        userImageView.setRounded()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.contentView.backgroundColor = Colors.veryLightPink
        } else {
            self.contentView.backgroundColor = .clear
        }
    }
    
    override func onSelected() {
        super.onSelected()
        guard let recentChat = self.recentChat else {
            return
        }
        delegate?.recentChatDidClicked(recentChat: recentChat)
        
    }
    
    func setContent(recentChat: RecentChat) {
        guard let member = recentChat.member, let lastMessage = recentChat.lastMessage else {
            return
        }
        self.recentChat = recentChat
        userImageView.loadIGSImage(link: member.profileUrl ?? "", placeholderImage: R.image.userPlacaholder())
        nameLabel.text = member.nickName
        if (lastMessage.type == "FILE"){
            lastMessageLabel.text = "sent you a photo"
        } else {
            lastMessageLabel.text = lastMessage.message
        }
        if let timestamp = lastMessage.createdAt, timestamp > 0 {
            let date = Date(timeIntervalSince1970: timestamp/1000)
            let style = RelativeFormatter.Style(flavours: [.short], gradation: .convenient(), allowedUnits: [.now, .minute, .hour, .day, .week, .month])
            dateLabel.text = date.toRelative(style: style, locale: Locales.english)
        } else {
            dateLabel.text = ""
        }
        
        if let totalUnread = recentChat.unreadMessageCount, totalUnread > 0 {
            unreadView.alpha = 1.0
            totalUnreadLabel.text = "\(totalUnread)"
        } else {
            unreadView.alpha = 0.0
        }
        if (member.isOnline == true) {
            onlineStatusView.backgroundColor = Colors.onlineYellow
        } else {
            onlineStatusView.backgroundColor = Colors.unselectGray
        }
    }
    
}
