//
//  MySpotTermsPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

class MySpotTermsPresenter : MKPresenter {
    
    private weak var view: MySpotRegisterTermsConditionVC?
    private var staticService : StaticPageServices?
    
    override init() {
        super.init()
        staticService = StaticPageServices()
    }
    
    func attachview(_ view: MySpotRegisterTermsConditionVC) {
        self.view = view
    }
    
    func getPolicy(){
        self.view?.showTermsLoadingView()
        staticService!.requestPage(success: {[weak self]
            (apiResponse) in
            self?.view?.hideTermsLoadingView()
            
            let list  = StaticPage.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setContent(text: list[0].description ?? "")
            }, failure: { [weak self] (error) in
//                self?.view?.hideTermsLoadingView()
                self?.view?.showTermsErrorView(message: "Oops, something went wrong, please try again later")
                print ("about error message : \(error.message)")
        })
        
        
        
    }
}
