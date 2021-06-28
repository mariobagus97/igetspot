////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol WithdrawalHistoryView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(withdrawalHistoryArray:[WithdrawalHistory])
}

class WithdrawalHistoryPresenter: MKPresenter {
    
    private weak var withdrawalHistoryView: WithdrawalHistoryView?
    private var withdrawalService: WithdrawalService?
    
    override init() {
        super.init()
        withdrawalService = WithdrawalService()
    }
    
    func attachview(_ view: WithdrawalHistoryView) {
        self.withdrawalHistoryView = view
    }
    
    func getAllWithdrawalHistory(userId:String) {
        withdrawalHistoryView?.showLoadingView()
        withdrawalService?.requestAllWithdrawalHistory(userId:userId, success: { [weak self] (apiResponse) in
            self?.withdrawalHistoryView?.hideLoadingView()
            let withdrawalHistoryArray = WithdrawalHistory.with(jsons: apiResponse.data.arrayValue)
            if withdrawalHistoryArray.isEmpty {
                self?.handleNoHistory()
            } else {
                self?.withdrawalHistoryView?.setContent(withdrawalHistoryArray: withdrawalHistoryArray)
            }
            }, failure: { [weak self] (error) in
                self?.withdrawalHistoryView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoHistory()
                } else {
                    self?.withdrawalHistoryView?.showEmptyView(withMessage: error.message,
                                                               description: nil,
                                                               buttonTitle: NSLocalizedString("Try Again", comment: ""),
                                                               emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoHistory() {
        withdrawalHistoryView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any withdrawal history", comment: ""),
                                                   description: nil,
                                                   buttonTitle: nil,
                                                   emptyCellButtonType:.error)
    }
    
}
