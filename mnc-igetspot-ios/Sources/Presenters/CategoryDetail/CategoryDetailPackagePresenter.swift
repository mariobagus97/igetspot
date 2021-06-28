//
//  CategoryDetailPackagePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol CategoryDetailPackageView : ParentProtocol {
    func setContent(categoryPackage: CategoryPackage)
}

class CategoryDetailPackagePresenter : MKPresenter {
    
    private weak var packageView: CategoryDetailPackageView?
    private var servicesService: ServicesService?
    
    override init() {
        super.init()
        servicesService = ServicesService()
    }
    
    func attachview(_ view: CategoryDetailPackageView) {
        self.packageView = view
    }
    
    func getPackage(parameters:[String:String]?) {
        packageView?.showLoading()
        servicesService?.requestCategoryPackage(parameters: parameters, success: { [weak self] (apiResponse) in
            self?.packageView?.hideLoading()
            let packages = CategoryPackage.with(json: apiResponse.data)
            self?.packageView?.setContent(categoryPackage: packages)
            }, failure: { [weak self] (error) in
                self?.packageView?.hideLoading()
                if error.statusCode == 3004 {
                    self?.packageView?.showEmpty?(NSLocalizedString("No package available for this category", comment: ""), nil)
                } else {
                    self?.packageView?.showEmpty?(StringConstants.MessageErrorAPI.tryAgainMessage,
                                                  NSLocalizedString("Try Again", comment: ""))
                }
        })
    }
}

