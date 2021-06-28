//
//  ServicesPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/7/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol ServicesView: ParentProtocol {
    func setContent(allServices: [AllServices])
}

class ServicesPresenter : MKPresenter {
    
    private weak var serviceView: ServicesView?
    private var servicesService: ServicesService?
    
    override init() {
        super.init()
        servicesService = ServicesService()
    }
    
    func attachview(_ view: ServicesView) {
        self.serviceView = view
    }
    
    func getServices(limit: Int){
        serviceView?.showLoading()
        servicesService?.requestAllServicesCategory(limit: "\(limit)", success: { [weak self] (apiResponse) in
            self?.serviceView?.hideLoading()
            let allServices = AllServices.with(jsons: apiResponse.data.arrayValue)
            if allServices.count == 0 {
                self?.serviceView?.showEmpty?(NSLocalizedString("No services available at the moment", comment: ""), nil)
            } else {
                self?.serviceView?.setContent(allServices: allServices)
            }
            }, failure: { [weak self] (error) in
                self?.serviceView?.hideLoading()
                if error.statusCode == 400 {
                    self?.serviceView?.showEmpty?(NSLocalizedString("No services available at the moment", comment: ""), nil)
                } else {
                    self?.serviceView?.showEmpty?(StringConstants.MessageErrorAPI.tryAgainMessage, NSLocalizedString("Try Again", comment: ""))
                }
        })
    }
}
