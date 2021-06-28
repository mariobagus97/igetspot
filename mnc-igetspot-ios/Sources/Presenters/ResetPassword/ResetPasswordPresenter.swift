//
//  ResetPasswordPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 23/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol ResetPasswordView: ParentProtocol {
    func moveVC()
    func moveToHome()
    func showLoadingProcess()
    func hideLoadingProcess()
}

class ResetPasswordPresenter: MKPresenter {
    private weak var view: ResetPasswordView?
    private var resetService: ResetPasswordService?
    
    override init() {
        super.init()
        resetService = ResetPasswordService()
    }
    
    func attachview(_ view: ResetPasswordView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func handlingLoginUser(){
        if(TokenManager.shared.isLogin()){
            view?.showErrorMessage?("Please logout this session before continuing to reset your password.")
            view?.moveToHome()
        }
    }
    
    func resetPassword(password: String, confirmPassword: String, token: String){
        view?.showLoadingProcess()
        resetService?.resetPassword(password: password, confirmPassword: confirmPassword, token: token, success: { [weak self] (apiResponse) in
            self?.view?.hideLoadingProcess()
            self?.view?.moveVC()
        }, failure:  { [weak self] (error) in
            self?.view?.hideLoadingProcess()
            self?.view?.showErrorMessage?(error.message)
        })
    }
    
}
