//
//  AboutPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol AboutView: ParentProtocol {
    func setAbout(text: String)
}

class AboutPresenter: MKPresenter {
    private weak var view: AboutView?
    private var staticService : StaticPageServices?
    
    override init() {
        super.init()
        staticService = StaticPageServices()
    }
    
    func attachview(_ view: AboutView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func getAbouttext(){
        self.view?.showLoading()
        staticService!.requestPage(success: {[weak self]
            (apiResponse) in
            
            self?.view?.hideLoading()
            let list  = StaticPage.with(jsons: apiResponse.data.arrayValue)
            self?.view?.setAbout(text: list[1].description ?? "")
            
            }, failure: { [weak self] (error) in
                print ("about error message : \(error.message)")
                self?.view?.showErrorMessage?("Oops, something went wrong, please try again later")
        })
      
    }
    
}
