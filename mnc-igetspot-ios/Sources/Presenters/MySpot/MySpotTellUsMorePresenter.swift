//
//  MySpotTellUsMorePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/26/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

class MySpotTellUsMorePresenter : MKPresenter {
    
    private weak var masterView: MySpotTellUsMore?
    private var mySpotRegistrationService : MySpotRegistrationService?
    
    override init() {
        super.init()
        mySpotRegistrationService = MySpotRegistrationService()
    }
    
    func attachview(_ view: MySpotTellUsMore) {
        self.masterView = view
    }
    
    func uploadRegistration(masterName: String, describeWork: String, workTime: String, instagram: String, linkedin: String, youtube: String, website: String){
        
        self.masterView?.showLoadingHUD()
        mySpotRegistrationService?.requestRegistrationMasterStepOne(masterName: masterName, describeWork: describeWork, workTime: workTime, instagram: instagram, linkedin: linkedin, youtube: youtube, website: website, success: { [weak self] (apiResponse) in
            self?.masterView?.hideLoadingHUD()
            self?.masterView?.successRegistration()
            }, failure: {[weak self] (error) in
                self?.masterView?.hideLoadingHUD()
                self?.masterView?.showErrorMessageBanner(error.message)
        })
    }
}
