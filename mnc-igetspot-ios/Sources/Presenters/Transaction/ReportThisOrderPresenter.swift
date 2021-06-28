////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ReportThisOrderDelegate:class {
    func showReportLoadingHUD()
    func hideReportLoadingHUD()
    func handleReportSuccess()
    func showMessageError(message:String)
}

class ReportThisOrderPresenter: MKPresenter {
    private weak var reportView: ReportThisOrderDelegate?
    var transactionService: TransactionService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: ReportThisOrderDelegate) {
        self.reportView = view
    }
    
    func postReportOrder(orderId:String, reason:String, reasonDescription:String) {
        reportView?.showReportLoadingHUD()
        transactionService?.requestReportOrder(orderId: orderId, reason: reason, reasonDescription: reasonDescription, success: { [weak self] (apiResponse) in
            self?.reportView?.hideReportLoadingHUD()
            self?.reportView?.handleReportSuccess()
            }, failure: { [weak self] (error) in
                self?.reportView?.hideReportLoadingHUD()
                self?.reportView?.showMessageError(message: error.message)
        })
    }
}
