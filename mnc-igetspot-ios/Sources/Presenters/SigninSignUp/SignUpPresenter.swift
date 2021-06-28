//
//  SignUpPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol SignUpView: ParentProtocol {
    func moveVC(email: String, password: String)
    func moveVC(fromSosmed token: String, type: SocialMediaLoginType, userid: String, email: String, isLogin: Bool)
}

class SignUpPresenter: MKPresenter {
    private weak var view: SignUpView?
    private var signupService: SignupService?
    private var tokenService: TokenService?
    
    override init() {
        super.init()
        signupService = SignupService()
        tokenService = TokenService()
    }
    
    func attachview(_ view: SignUpView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func signUpEmail(email: String, password: String){
        view?.showLoading()
        signupService?.requestRegisterUser(email, password: password, password2:password,  success: { [weak self] (apiResponse) in
//            self?.view?.hideLoading()
            let json = apiResponse.data
            TokenManager.shared.saveToken(fromJSON: json, email: email)
            self?.view?.moveVC(email: email, password: password)
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
    
    func signInSosmed(token: String, type: SocialMediaLoginType, userid: String, email: String, isLogin:Bool){
        view?.showLoading()
        tokenService?.requestTokenSocialMedia(token, userId: userid, email: email, typeLogin: type, isLogin: true, success: { [weak self] (apiResponse) in
//            self?.view?.hideLoading()
            let json = apiResponse.data
            TokenManager.shared.saveToken(fromJSON: json, email: email)
            self?.view?.moveVC(fromSosmed: token, type: type, userid: userid, email: email, isLogin: isLogin)
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
}
