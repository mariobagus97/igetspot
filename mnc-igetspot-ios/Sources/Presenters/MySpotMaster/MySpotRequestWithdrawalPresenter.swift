////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotRequestWithdrawalView: class {
    func showLoadingProcessWithdrawal()
    func hideLoadingProcessWithdrawal()
    func handleErrorRequestWithDrawal(errorMessage:String) 
    func handleSuccessRequestWithDrawal()
}

class MySpotRequestWithdrawalPresenter: MKPresenter {
    private weak var requestWithdrawalView: MySpotRequestWithdrawalView?
    var withdrawalService: WithdrawalService?
    
    override init() {
        super.init()
        withdrawalService = WithdrawalService()
    }
    
    func attachview(_ view: MySpotRequestWithdrawalView) {
        self.requestWithdrawalView = view
    }
    
    func requestWithdrawal(amount:String, password:String) {
        requestWithdrawalView?.showLoadingProcessWithdrawal()
        withdrawalService?.requestWithdrawal(amount: amount, password: password, success: { [weak self] (apiResponse) in
            self?.requestWithdrawalView?.hideLoadingProcessWithdrawal()
            self?.requestWithdrawalView?.handleSuccessRequestWithDrawal()
            }, failure: { [weak self] (error) in
                self?.requestWithdrawalView?.hideLoadingProcessWithdrawal()
                self?.requestWithdrawalView?.handleErrorRequestWithDrawal(errorMessage: error.message)
        })
    }
}
