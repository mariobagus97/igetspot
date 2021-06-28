//
//  UserAgreementPresenter.swift
//  mnc-igetspot-ios
//
//  Created by Ari Fajrianda Alfi on 09/06/20.
//  Copyright © 2020 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol UserAgreementView: ParentProtocol {
    func setContent(agreement: String)
}

class UserAgreementPresenter: MKPresenter {
    private weak var view: UserAgreementView?
    private var staticService : StaticPageServices?
    
    override init() {
            super.init()
            staticService = StaticPageServices()
        }
        
        func attachview(_ view: UserAgreementView) {
            self.view = view
        }
        
        func getUserAgreement(){
            self.view?.showLoading()
            staticService!.requestPage(success: {[weak self]
                (apiResponse) in
                self?.view?.hideLoading()
                let list  = StaticPage.with(jsons: apiResponse.data.arrayValue)
                self?.view?.setContent(agreement: list[0].description ?? "")
                }, failure: { [weak self] (error) in
                    self?.view?.showErrorMessage?("Oops, something went wrong, please try again later")
                    print ("about error message : \(error.message)")
            })
        }
}
