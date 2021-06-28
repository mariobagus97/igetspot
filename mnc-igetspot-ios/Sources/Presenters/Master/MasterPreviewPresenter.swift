//
//  MasterPreviewPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire

protocol MasterPreviewView: ParentProtocol {
    func setContent (masters: [MasterPreview])
    func noMoreData()
}

class MasterPreviewPresenter: MKPresenter {
    
    private weak var view: MasterPreviewView?
    private var masterService: MasterService?
    
    override init() {
        super.init()
        masterService = MasterService()
    }
    
    func attachview(_ view: MasterPreviewView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func getAllMaster(withPage page:Int, andSearch search:String) {
        if (page == 1){
            view?.showLoading()
        }
        let limit:Int = 20
        masterService?.requestMasterAll(withPage: page, search: search, limit: limit, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let masterPreviewArray = MasterPreview.with(jsons: apiResponse.data.arrayValue)
            if (masterPreviewArray.count == 0 && page == 1) {
                self?.view?.showEmpty?(NSLocalizedString("No Master Available", comment: ""), nil)
            } else {
                self?.view?.setContent(masters: masterPreviewArray)
            }
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                if (error.statusCode == 400) {
                    self?.view?.noMoreData()
                    if (page == 1) {
                        self?.view?.showEmpty?(NSLocalizedString("No Master Available", comment: ""), nil)
                    }
                } else {
                    self?.view?.showEmpty?(error.message,  NSLocalizedString("Try Again", comment: ""))
                }
        })
    }
    
}
