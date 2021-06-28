//
//  CategoryDetailMasterPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol CategoryDetailMasterView : ParentProtocol {
    func setContent(categoryMaster: CategoryMaster)
}

class CategoryDetailMasterPresenter : MKPresenter {
    
    private weak var masterView: CategoryDetailMasterView?
    private var servicesService: ServicesService?
    
    override init() {
        super.init()
        servicesService = ServicesService()
    }
    
    func attachview(_ view: CategoryDetailMasterView) {
        self.masterView = view
    }
    
    func getMaster(parameters:[String:String]?) {
        masterView?.showLoading()
        servicesService?.requestCategoryMaster(parameters:parameters, success: { [weak self] (apiResponse) in
            self?.masterView?.hideLoading()
            let masters = CategoryMaster.with(json: apiResponse.data)
            self?.masterView?.setContent(categoryMaster: masters)
            }, failure: { [weak self] (error) in
                self?.masterView?.hideLoading()
                if error.statusCode == 3004 {
                    self?.masterView?.showEmpty?(NSLocalizedString("No master available for this category", comment: ""), nil)
                } else {
                    self?.masterView?.showEmpty?(StringConstants.MessageErrorAPI.tryAgainMessage,
                                                 NSLocalizedString("Try Again", comment: ""))
                }
        })
    }
}
