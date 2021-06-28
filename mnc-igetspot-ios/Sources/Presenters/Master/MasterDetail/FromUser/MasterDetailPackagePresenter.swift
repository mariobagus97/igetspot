//
//  MasterDetailPackagePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol MasterDetailPackageView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String)
    func setContent(packageLists : [PackageList])
}

class MasterDetailPackagePresenter : MKPresenter {
    
    private weak var masterView: MasterDetailPackageView?
    private var masterService: MasterService?
    
    override init() {
        super.init()
        masterService = MasterService()
    }
    
    func attachview(_ view: MasterDetailPackageView) {
        self.masterView = view
    }
    
    func getDetailPackage(forMasterId masterId: String) {
        masterView?.showLoadingView()
        masterService?.requestMasterPackages(masterId: masterId, success: { [weak self] (apiResponse) in
            let masterpackage = MasterPackage.with(json: apiResponse.data)
            let packagesArray = masterpackage.packages!
            if packagesArray.count == 0 {
                self?.masterView?.showEmptyView(withMessage: NSLocalizedString("No Package Available", comment: ""))
            } else {
                self?.masterView?.hideLoadingView()
                self?.masterView?.setContent(packageLists: packagesArray)
            }
            }, failure:  { [weak self] (error) in
                self?.masterView?.showEmptyView(withMessage: error.message)
        })
    }
 
}
