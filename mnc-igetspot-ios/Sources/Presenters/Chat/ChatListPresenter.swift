////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

protocol ChatListView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(recentChatListArray:[RecentChat])
}

class ChatListPresenter: MKPresenter {
    
    private weak var chatView: ChatListView?
    private var chatService: ChatService?
    
    override init() {
        super.init()
        chatService = ChatService()
    }
    
    func attachview(_ view: ChatListView) {
        self.chatView = view
    }
    
    func getRecentChats(keyword:String = "") {
        chatView?.showLoadingView()
        chatService?.requestRecentChatList(keyword: keyword, success: { [weak self] (apiResponse) in
            self?.chatView?.hideLoadingView()
            guard let userId = TokenManager.shared.getUserId() else {
                return
            }
            let recentChatArray = RecentChat.with(jsons: apiResponse.data["channels"].arrayValue, currentUserId: userId)
            if (recentChatArray.count == 0) {
                self?.handleNoRecentChat()
            } else {
                self?.chatView?.setContent(recentChatListArray: recentChatArray)
            }
            }, failure: { [weak self] (error) in
                self?.chatView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoRecentChat()
                } else {
                    self?.chatView?.showEmptyView(withMessage: "You dont have any chat about \(keyword)", description: "",
                                                      buttonTitle: "",
                                                      emptyCellButtonType:.error)
                }
        })
 
    }

    func handleNoRecentChat() {
        chatView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any chat", comment: ""),
                                    description: NSLocalizedString("Start searching and chat with the masters", comment: ""),
                                    buttonTitle: NSLocalizedString("Start Browsing", comment: ""), emptyCellButtonType:.start)
    }
}
