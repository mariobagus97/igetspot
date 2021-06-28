//
//  SignOutPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/1/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol SignOutView: ParentProtocol {
    
}

class SignOutPresenter: MKPresenter {
    private weak var view: SignOutView?
    private var tokenService: TokenService?
    private var signOutService : SignOutService?
    
    override init() {
        super.init()
        tokenService = TokenService()
        signOutService = SignOutService()
    }
    
    func attachview(_ view: SignOutView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func signOut() {
        view?.showLoading()
        signOutService?.signOut(success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            TokenManager.shared.logOut()
        }, failure: { [weak self] (error) in
            self?.view?.hideLoading()
            TokenManager.shared.logOut()
        })
    }

}
