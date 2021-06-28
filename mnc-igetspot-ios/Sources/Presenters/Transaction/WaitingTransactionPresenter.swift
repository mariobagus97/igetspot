////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol WaitingTransactionView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(transactionArray:[WaitingTransaction])
    func showTransactionLoadingHUD()
    func hideTransactionLoadingHUD()
    func showMessageError(message:String)
    func showMessageSuccess(message:String)
    func handleSuccessDelete()
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String)
}

class WaitingTransactionPresenter: MKPresenter {
    
    private weak var waitingTransactionView: WaitingTransactionView?
    private var transactionService: TransactionService?
    private var chatService: ChatService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
        chatService = ChatService()
    }
    
    func attachview(_ view: WaitingTransactionView) {
        self.waitingTransactionView = view
    }
    
    func getTransactionWaitingList() {
        waitingTransactionView?.showLoadingView()
        transactionService?.requestTransactionWaitingList(success: { [weak self] (apiResponse) in
            self?.waitingTransactionView?.hideLoadingView()
            let transactionArray = WaitingTransaction.with(jsons: apiResponse.data.arrayValue)
            if transactionArray.isEmpty {
                self?.handleNoWaitingTransaction()
            } else {
               self?.waitingTransactionView?.setContent(transactionArray: transactionArray)
            }
            }, failure: { [weak self] (error) in
                self?.waitingTransactionView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoWaitingTransaction()
                } else {
                    self?.waitingTransactionView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }

    func handleNoWaitingTransaction() {
        waitingTransactionView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of waiting transaction", comment: ""),
                                        description: NSLocalizedString("Start searching and doing business with us", comment: ""),
                                        buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
    }
    
    func deleteTransactionPackage(orderId:String, packageId:String) {
        waitingTransactionView?.showTransactionLoadingHUD()
        transactionService?.requestDeletePackageWaitingTransaction(orderId: orderId, packageId: packageId, success: { [weak self] (apiResponse) in
            self?.waitingTransactionView?.hideTransactionLoadingHUD()
            self?.waitingTransactionView?.showMessageSuccess(message: NSLocalizedString("The Package has been deleted", comment: ""))
            self?.waitingTransactionView?.handleSuccessDelete()
            }, failure: { [weak self] (error) in
                self?.waitingTransactionView?.hideTransactionLoadingHUD()
                self?.waitingTransactionView?.showMessageError(message: error.message)
        })
    }
    
    func getChannelRoom(currentUserId:String, opponentId:String) {
        waitingTransactionView?.showTransactionLoadingHUD()
        chatService?.requestChannelRoom(currentUserId: currentUserId, opponentId: opponentId, success: { [weak self] (apiResponse) in
            self?.waitingTransactionView?.hideTransactionLoadingHUD()
            let responseData = apiResponse.data
            if let channelUrl = responseData["channel_url"].string, channelUrl.isEmptyOrWhitespace() == false {
                let phoneNumber = responseData["phone_number"].stringValue
                let opponentId = responseData["user_id"].stringValue
                let profileImageUrl = responseData["profile_url"].stringValue
                let nickName = responseData["nickname"].stringValue
                self?.waitingTransactionView?.goToChatRoom(channelUrl: channelUrl, opponentId: opponentId, profileImageUrl: profileImageUrl, nickName: nickName, phoneNumber: phoneNumber)
            } else {
                self?.waitingTransactionView?.showMessageError(message: NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
            }
            }, failure: { [weak self] (error) in
                self?.waitingTransactionView?.hideTransactionLoadingHUD()
                self?.waitingTransactionView?.showMessageError(message: error.message)
        })
    }
}
