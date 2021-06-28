//
//  MasterDetailServicePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/16/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//
import Foundation

protocol MasterDetailServiceView:class {
    func handleServiceEmpty()
    func setContentServices(serviceList : [ServiceCategory])
}

class MasterDetailServicePresenter : MKPresenter {
    
    private weak var masterView: MasterDetailServiceView?
    private var masterService: MasterService?
    
    override init() {
        super.init()
        masterService = MasterService()
    }
    
    func attachview(_ view: MasterDetailServiceView) {
        self.masterView = view
    }
    
    func getMasterService(forMasterId masterId: String) {
        masterService?.requestMasterServices(masterId: masterId, success: { [weak self]  (apiResponse) in
            let serviceCategories = ServiceCategory.with(jsons: apiResponse.data.arrayValue)
            if serviceCategories.count == 0 {
                self?.masterView?.handleServiceEmpty()
            } else {
                self?.masterView?.setContentServices(serviceList: serviceCategories)
            }
            }, failure: { [weak self]  (error) in
                self?.masterView?.handleServiceEmpty()
        })
    }
    
}
