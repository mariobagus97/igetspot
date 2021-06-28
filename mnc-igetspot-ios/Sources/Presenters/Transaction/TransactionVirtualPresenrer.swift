//
//  TransactionVirtualPresenrer.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 04/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol TransactionVirtualAccountView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(data: TransactionVirtualAccount)
}

class TransactionVirtualPresenter: MKPresenter {
    
    private weak var view: TransactionVirtualAccountView?
    private var transactionService: TransactionService?
    
    private var virtualAccountData : TransactionVirtualAccount!
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: TransactionVirtualAccountView) {
        self.view = view
    }
    
    func getVANumber(txId:String){
        self.view?.showLoadingView()
        transactionService?.getVANumber(txId:txId, success: { [weak self] (apiResponse) in
            self?.view?.hideLoadingView()
            let data = TransactionVirtualAccount.with(json: apiResponse.data)
            self?.view?.setContent(data: data)
            }, failure:  { [weak self] (error) in
                self?.view?.hideLoadingView()
                self?.view?.showEmptyView(withMessage: error.message, description: nil, buttonTitle: NSLocalizedString("Try Again", comment: ""), emptyCellButtonType: .error)
        })
    }
}
