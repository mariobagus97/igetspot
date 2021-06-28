//
//  TransactionPaymentPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//
import Foundation

protocol TransactionPaymentView:class {
    func showTransactionLoadingHUD()
    func hideTransactionLoadingHUD()
    func showPaymentLoadingView()
    func hidePaymentLoadingView()
    func setBank(bankList: [Bank])
    func hasCompletedProfile()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func showMessageError(message:String)
    func showVA(txId: String)
}

class TransactionPaymentPresenter: MKPresenter {
    
    private weak var view: TransactionPaymentView?
    private var transactionService: TransactionService?
    private var bankService: BankService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
        bankService = BankService()
    }
    
    func attachview(_ view: TransactionPaymentView) {
        self.view = view
    }
    
    func getBankList(){
        self.view?.showPaymentLoadingView()
        transactionService?.requestBankList(success: { [weak self] (apiResponse) in
            self?.view?.hidePaymentLoadingView()
            let list  = BankPayment.with(jsons: apiResponse.data.arrayValue)
//            self?.view?.setBank(bankList: list)
            }, failure:  { [weak self] (error) in
                self?.view?.hidePaymentLoadingView()
                self?.view?.showEmptyView(withMessage: error.message, description: nil, buttonTitle: NSLocalizedString("Try Again", comment: ""), emptyCellButtonType: .error)
        })
        
    }
    
    func getBank(){
        self.view?.showPaymentLoadingView()
        bankService?.requestBankList(success: { [weak self] (apiResponse) in
            self?.view?.hidePaymentLoadingView()
            let list  = Bank.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setBank(bankList: list)
            }, failure:  { [weak self] (error) in
                self?.view?.hidePaymentLoadingView()
                self?.view?.showEmptyView(withMessage: error.message, description: nil, buttonTitle: NSLocalizedString("Try Again", comment: ""), emptyCellButtonType: .error)
                
        })
    }
    
    func getVA(orderID: String,invoiceID:String?, paymentMethod: String, bankCode: String){
        self.view?.showTransactionLoadingHUD()
        transactionService?.registrationVA(order_id: orderID,invoice_id: invoiceID, paymentMethod: paymentMethod, bankCode: bankCode, success: { [weak self] (apiResponse) in
            self?.view?.hideTransactionLoadingHUD()
            let data  = RegisVA.with(json: apiResponse.data)
            self?.view?.showVA(txId : data.txId ?? "0")
            }, failure:  { [weak self] (error) in
                self?.view?.hideTransactionLoadingHUD()
                self?.view?.showMessageError(message: error.message)
        })
    }
    
    func profileHasBeenCompleted(){
        let userProfile = UserProfileManager.shared.getUser()
        if (userProfile?.address == ""){
            view?.showMessageError(message: "Please complete your address in profile")
            return
        }
        
        if ( userProfile?.phone == ""){
            view?.showMessageError(message: "Please complete your phone number in profile")
            return
        }
        
//        if ( userProfile?.bankId == ""){
//            view?.showMessageError(message: "Please complete your bank id in profile")
//            return
//        }
        
        view?.hasCompletedProfile()
    }
}
