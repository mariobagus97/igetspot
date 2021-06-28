////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol TransactionDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(transactionDetail:TransactionDetail)
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? )
}

class TransactionDetailPresenter: MKPresenter {
    private weak var detailView: TransactionDetailView?
    var transactionService: TransactionService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: TransactionDetailView) {
        self.detailView = view
    }
    
    func getTransactionDetail(packageId:String, transactionId:String) {
        detailView?.showLoadingView()
        transactionService?.requestTransactionDetail(transactionId: transactionId, packageId: packageId, success: { [weak self] (apiResponse) in
            self?.detailView?.hideLoadingView()
            let transactionDetail = TransactionDetail.with(json: apiResponse.data)
            self?.detailView?.setContent(transactionDetail: transactionDetail)
            }, failure: { [weak self] (error) in
                self?.detailView?.hideLoadingView()
                self?.detailView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                    buttonTitle: NSLocalizedString("Try Again", comment: ""),
                    emptyCellButtonType:.error)
        })
        
    }
}
