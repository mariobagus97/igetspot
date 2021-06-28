//
//  PrivacyPolicyPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol PrivacyView: ParentProtocol {
    func setContent(policy: String)
}

class PrivacyPolicyPresenter : MKPresenter {
    
    private weak var view: PrivacyView?
    private var staticService : StaticPageServices?
    
    override init() {
        super.init()
        staticService = StaticPageServices()
    }
    
    func attachview(_ view: PrivacyView) {
        self.view = view
    }
    
    func getPolicy(){
        self.view?.showLoading()
        staticService!.requestPage(success: {[weak self]
            (apiResponse) in
            self?.view?.hideLoading()
            let list  = StaticPage.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setContent(policy: list[2].description ?? "")
            }, failure: { [weak self] (error) in
//                self?.view?.hidePolicyLoadingView()
                self?.view?.showErrorMessage?("Oops, something went wrong, please try again later")
                print ("about error message : \(error.message)")
        })
       
    }
}
