//
//  MySpotRegisStep3Presenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/28/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

class MySpotRegisStep3Presenter : MKPresenter {
    
    private weak var masterView: MySpotRegisStep3VC?
    private var mySpotRegistrationService: MySpotRegistrationService?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: MySpotRegisStep3VC) {
        self.masterView = view
        mySpotRegistrationService = MySpotRegistrationService()
    }
    
    func uploadRegistration(registrationData : MySpotRegisStep3){
        let parameters = self.buildParameters(registrationData: registrationData)
        self.masterView?.showLoadingHUD()
        mySpotRegistrationService?.requestRegistrationMasterStepThree(parameters: parameters, success: { [weak self] (apiResponse) in
            self?.masterView?.hideLoadingHUD()
            self?.masterView?.successRegistration()
            }, failure: {[weak self] (error) in
                self?.masterView?.hideLoadingHUD()
                self?.masterView?.showErrorMessageBanner(error.message)
        })
    }
    
    func buildParameters(registrationData : MySpotRegisStep3) -> Parameters? {
        
        guard let photoIdImage = registrationData.photoId, let selfieImage = registrationData.selfieId, let idcard = registrationData.idCard, let acceptTerm = registrationData.acceptTerm else {
            return nil
        }
        
        let parameters = [MySpotRegisStep3.KEY_ID_CARD:idcard,
                          MySpotRegisStep3.KEY_ACCEPT_TERM: "1",
                          MySpotRegisStep3.KEY_PHOTO_ID:photoIdImage.jpgToBase64String(),
                          MySpotRegisStep3.KEY_SELFIE_ID:selfieImage.jpgToBase64String()]
        
        return parameters
    }
    
}
