//
//  MySpotWhatToOfferPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/27/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

class MySpotWhatToOfferPresenter : MKPresenter {
    
    private weak var masterView: MySpotWhatToOfferVC?
    private var servicesService: ServicesService?
    private var mySpotRegistrationService: MySpotRegistrationService?
    private var mySpotMasterDetailEditService: MySpotMasterDetailEditService?
    
    override init() {
        super.init()
        servicesService = ServicesService()
        mySpotRegistrationService = MySpotRegistrationService()
        mySpotMasterDetailEditService = MySpotMasterDetailEditService()
    }
    
    func attachview(_ view: MySpotWhatToOfferVC) {
        self.masterView = view
    }
    
    func getCategoryList(limit:Int) {
        servicesService?.requestAllServicesCategory(limit: "\(limit)", success: { [weak self] (apiResponse) in
            let allServices = AllServices.with(jsons: apiResponse.data.arrayValue)
            self?.masterView?.setAllCategoryList(list: allServices)
        }) {(error) in
                
        }
    }
    
    func uploadRegistration(registrationData : [MySpotWhatToOffer]){
        let parameters = buildParameters(registrationData: registrationData)
        if parameters.count > 0 {
            masterView?.showLoadingHUD()
            mySpotRegistrationService?.requestRegistrationMasterStepTwo(parameters: parameters, success: { [weak self] (apiResponse) in
                self?.masterView?.hideLoadingHUD()
                self?.masterView?.handleRegistrationSuccess()
                }, failure: {[weak self] (error) in
                    self?.masterView?.hideLoadingHUD()
                    self?.masterView?.showErrorMessageBanner(error.message)
            })
        }
    }
    
    func savePackageMySpot(data:[MySpotWhatToOffer]) {
        let parameters = buildParameters(registrationData: data)
        if parameters.count > 0 {
            masterView?.showLoadingHUD()
            mySpotMasterDetailEditService?.requestAddPackage(parameters: parameters, success: { [weak self] (apiResponse) in
                self?.masterView?.hideLoadingHUD()
                self?.masterView?.handleRegistrationSuccess()
                }, failure: {[weak self] (error) in
                    self?.masterView?.hideLoadingHUD()
                    self?.masterView?.showErrorMessageBanner(error.message)
            })
        }
    }
    
    func buildParameters(registrationData : [MySpotWhatToOffer]) -> Parameters {
        var parameters = [[String:Any]]()
        
        for row in 0...registrationData.count-1 {
            var data = [String:Any]()
            if let category = registrationData[row].categoryId {
                data[MySpotWhatToOffer.KEY_CATEGORY_ID] = String(category)
            }
            if let subcategory = registrationData[row].subcategoryId {
                data[MySpotWhatToOffer.KEY_SUBCATEGORY_ID] = String(subcategory)
            }
            data[MySpotWhatToOffer.KEY_SERVICE_PACKAGE_DESCRIPTION] = registrationData[row].packageDescription
            data[MySpotWhatToOffer.KEY_SERVICE_PACKAGE_NAME] = registrationData[row].servicePackageName
            data[MySpotWhatToOffer.KEY_PACKAGE_PRICE] = registrationData[row].packagePrice
            
            var durationString = ""
            if let duration = registrationData[row].packageDuration {
                durationString = "\(duration) Hours"
            }
            data[MySpotWhatToOffer.KEY_PACKAGE_DURATION] = durationString
            
            var images = [String]()
            
            if let packages = registrationData[row].packageImage {
                for i in 0...packages.count - 1 {
                    var packageParams = [String:Any]()
                    packageParams[PackageImage.KEY_FILE] = registrationData[row].packageImage![i].file?.jpgToBase64String()
                    images.append(packageParams[PackageImage.KEY_FILE] as! String)
                }
            }
            
            data[MySpotWhatToOffer.KEY_PACKAGE_IMAGE] = images
            parameters.append(data)
        }
        return parameters.asParameters()
    }
}
