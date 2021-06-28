////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterAboutView:class {
    func showLoadingAboutView()
    func hideLoadingAboutView()
    func setContentMasterDescription(_ description : String)
    func showErrorView(withMessage message:String)
    func handleServiceEmpty()
    func showMasterService(serviceList : [ServiceCategory])
    func showMySpotLoadingHUD()
    func hideMySpotLoadingHUD()
    func showMessageError(message:String)
    func showMessageSuccess(message:String)
    func handleSuccessEditAboutMaster(about:String)
}

class MySpotMasterAboutPresenter: MKPresenter {
    private weak var masterView: MySpotMasterAboutView?
    private var masterService: MySpotMasterDetailService?
    private var masterEditService: MySpotMasterDetailEditService?
    
    override init() {
        super.init()
        masterService = MySpotMasterDetailService()
        masterEditService = MySpotMasterDetailEditService()
    }
    
    func attachview(_ view: MySpotMasterAboutView) {
        self.masterView = view
    }
    
    func getMySpotMasterAbout(masterId: String) {
        masterView?.showLoadingAboutView()
        masterService?.requestMySpotAbout(masterId: masterId, success: { [weak self]  (apiResponse) in
            self?.masterView?.hideLoadingAboutView()
            let about = apiResponse.data.stringValue
            self?.masterView?.setContentMasterDescription(about)
            }, failure: { [weak self]  (error) in
                self?.masterView?.hideLoadingAboutView()
                self?.masterView?.showErrorView(withMessage: StringConstants.MessageErrorAPI.tryAgainMessage)
        })
    }
    
    func getMasterService(forMasterId masterId: String) {
        masterService?.requestMySpotServices(masterId: masterId, success: { [weak self]  (apiResponse) in
            let serviceCategories = ServiceCategory.with(jsons: apiResponse.data.arrayValue)
            if serviceCategories.count == 0 {
                self?.masterView?.handleServiceEmpty()
            } else {
                self?.masterView?.showMasterService(serviceList: serviceCategories)
            }
            }, failure: { [weak self]  (error) in
                self?.masterView?.handleServiceEmpty()
        })
    }
    
    func editAboutMaster(contentString: String) {
        masterView?.showMySpotLoadingHUD()
        masterEditService?.requestEditAbout(contentString: contentString, success: { [weak self]  (apiResponse) in
            self?.masterView?.hideMySpotLoadingHUD()
            self?.masterView?.showMessageSuccess(message: NSLocalizedString("Update about success", comment: ""))
            self?.masterView?.handleSuccessEditAboutMaster(about: contentString)
            }, failure: { [weak self]  (error) in
                self?.masterView?.hideMySpotLoadingHUD()
                self?.masterView?.showMessageError(message: error.message)
        })
    }
}
