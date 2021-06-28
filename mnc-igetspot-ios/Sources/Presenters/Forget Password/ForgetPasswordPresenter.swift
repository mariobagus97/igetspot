//
//  ForgetPasswordPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/21/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol ForgetPasswordPresenterView : ParentProtocol {
    
}

class ForgetPasswordPresenter: MKPresenter {
    
    private weak var view: ForgetPasswordPresenterView?
    private var forgotPasswordService: ForgotPasswordService?
    
    override init() {
        super.init()
        forgotPasswordService = ForgotPasswordService()
    }
    
    func attachview(_ view: ForgetPasswordPresenterView) {
        self.view = view
    }
    
    func sendForgetPassword(email : String) {
        view?.showLoading()
        // TODO: Handle Forgot Password
        forgotPasswordService?.requestForgotPassword(email: email, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            self?.view?.showSuccessMessage?("Password reset instruction has been sent to your e-mail. Please kindly check your inbox/spam.")
            
            }, failure: { [weak self] (error) in
              self?.view?.hideLoading()
            self?.view?.showErrorMessage?(error.message)
        })
    }
}
