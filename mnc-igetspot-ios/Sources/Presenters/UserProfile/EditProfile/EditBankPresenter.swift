//
//  EditBankPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import Alamofire

protocol EditBankView: ParentProtocol {
    func setContent(list: [Bank])
    func setEditProfileData(bankDetail: UserBankDetail)
    func editOrAddBankSuccess()
}

class EditBankPresenter : MKPresenter {
    
    private weak var profileView: EditBankView?
    private var editProfileService: EditProfileService?
    private var bankService: BankService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
        bankService = BankService()
    }
    
    func attachview(_ view: EditBankView) {
        self.profileView = view
    }
    
    func editProfile(bankId: String, accountHolder: String, accountNo: String, password: String)  {
        self.profileView?.showLoading()
        editProfileService?.requestEditProfileBank(bankId:bankId, accountHolder: accountHolder, accountNumber: accountNo, password: password, success: { [weak self] (apiResponse) in
            self?.profileView?.hideLoading()
            self?.profileView?.editOrAddBankSuccess()
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage!(error.message)
//                    .showErrorMessageBanner(error.message)
        })
    }
    
    
    func getBankList(){
        bankService?.requestBankList(success: { [weak self] (apiResponse) in
            let list  = Bank.with(jsons: apiResponse.data.arrayValue)
            self?.profileView?.setContent(list: list)
            }, failure:  { [weak self] (error) in
                
        })
        
    }
    
    func getUserBankDetail(){
        editProfileService?.requestUserBankDetail(success: { [weak self] (apiResponse) in
            let data  = UserBankDetail.with(json: apiResponse.data)
            self?.profileView?.setEditProfileData(bankDetail: data)
            }, failure:  { [weak self] (error) in
                
        })
    }
    
}
