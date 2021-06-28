////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ActiveTransactionView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(transactionArray:[ActiveTransaction])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func showTransactionLoadingHUD()
    func hideTransactionLoadingHUD()
    func showMessageError(message:String)
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String)
}

class ActiveTransactionPresenter: MKPresenter {
    private weak var transactionView: ActiveTransactionView?
    private var transactionService: TransactionService?
    private var chatService: ChatService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
        chatService = ChatService()
    }
    
    func attachview(_ view: ActiveTransactionView) {
        self.transactionView = view
    }
    
    func getTransactionActiveList() {
        transactionView?.showLoadingView()
        transactionService?.requestTransactionActiveList(success: { [weak self] (apiResponse) in
            self?.transactionView?.hideLoadingView()
            let transactionArray = ActiveTransaction.with(jsons: apiResponse.data.arrayValue)
            if transactionArray.isEmpty {
                self?.handleNoActiveTransaction()
            } else {
                self?.transactionView?.setContent(transactionArray: transactionArray)
            }
            }, failure: { [weak self] (error) in
                self?.transactionView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoActiveTransaction()
                } else {
                    self?.transactionView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoActiveTransaction() {
        transactionView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of active transaction", comment: ""),
                                              description: NSLocalizedString("Start searching and doing business with us", comment: ""),
                                              buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
    }
    
    func getChannelRoom(currentUserId:String, opponentId:String) {
        transactionView?.showTransactionLoadingHUD()
        chatService?.requestChannelRoom(currentUserId: currentUserId, opponentId: opponentId, success: { [weak self] (apiResponse) in
            self?.transactionView?.hideTransactionLoadingHUD()
            let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                self?.transactionView?.goToChatRoom(channelUrl: channelUrl, opponentId: opponentId, profileImageUrl: profileImageUrl, nickName: nickName, phoneNumber: phoneNumber)
            } else {
                self?.transactionView?.showMessageError(message: NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            }, failure: { [weak self] (error) in
                self?.transactionView?.hideTransactionLoadingHUD()
                self?.transactionView?.showMessageError(message: error.message)
        })
    }
}
