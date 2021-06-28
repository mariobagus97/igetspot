////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TransactionStatusView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? )
    func setContent(transactionStatusArray:[TransactionStatus])
}

class TransactionStatusPresenter: MKPresenter {
    
    private weak var transactionView: TransactionStatusView?
    private var transactionService: TransactionService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: TransactionStatusView) {
        self.transactionView = view
    }
    
    func getTransactionStatusList(orderId:String, packageId:String) {
        transactionView?.showLoadingView()
        transactionService?.requestTransactionStatus(orderId: orderId, packageId: packageId, success: { [weak self] (apiResponse) in
            self?.transactionView?.hideLoadingView()
            let transactionStatusArray = TransactionStatus.with(jsons: apiResponse.data.arrayValue)
            if transactionStatusArray.isEmpty {
                self?.transactionView?.showEmptyView(withMessage: NSLocalizedString("Ooops, something went wrong. Please try again..", comment: ""), description: nil,
                    buttonTitle: NSLocalizedString("Try Again", comment: ""),
                    emptyCellButtonType:.error)
            } else {
                self?.transactionView?.setContent(transactionStatusArray: transactionStatusArray)
            }
            }, failure: { [weak self] (error) in
                self?.transactionView?.hideLoadingView()
                self?.transactionView?.showEmptyView(withMessage: error.message, description: nil,
                                                     buttonTitle: NSLocalizedString("Try Again", comment: ""),
                                                     emptyCellButtonType:.error)
        })
    }
}
