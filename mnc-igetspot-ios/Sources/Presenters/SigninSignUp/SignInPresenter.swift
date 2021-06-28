//
//  SignInPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol SignInView: ParentProtocol {
    func moveVC()
}

class SignInPresenter: MKPresenter {
    private weak var view: SignInView?
    private var tokenService: TokenService?
    
    override init() {
        super.init()
        tokenService = TokenService()
    }
    
    func attachview(_ view: SignInView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func signInEmail(email: String, password: String) {
        view?.showLoading()
        tokenService?.requestToken(email, password: password, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let json = apiResponse.data
            TokenManager.shared.saveToken(fromJSON: json, email: email)
            self?.view?.moveVC()
        
        }, failure: {[weak self] (error) in
            self?.view?.hideLoading()
            var errorMessage = error.message
            if error.statusCode == 400 {
                errorMessage = NSLocalizedString("Oopps, You have entered an invalid email or password, please check and try again", comment: "")
            }
            self?.view?.showErrorMessage?(errorMessage)
        })
    }
    
    func signInSosmed(token: String, type: SocialMediaLoginType, userid: String, email: String, isLogin:Bool){
        view?.showLoading()
        tokenService?.requestTokenSocialMedia(token, userId: userid, email: email, typeLogin: type, isLogin: true, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let json = apiResponse.data
            TokenManager.shared.saveToken(fromJSON: json, email: email)
            self?.view?.moveVC()
            
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
}
