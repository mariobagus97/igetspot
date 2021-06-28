////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView()
    func setContent(mySpotMasterDetail: MySpotMasterDetail)
}

class MySpotMasterDetailPresenter: MKPresenter {
    
    private weak var masterView: MySpotMasterDetailView?
    private var masterService: MySpotMasterDetailService?
    
    override init() {
        super.init()
        masterService = MySpotMasterDetailService()
    }
    
    func attachview(_ view: MySpotMasterDetailView) {
        self.masterView = view
    }
    
    func getMasterDetail(forMasterId masterId: String) {
        masterView?.showLoadingView()
        masterService?.requestMySpotDetail(masterId: masterId, success: { [weak self] (apiResponse) in
            self?.masterView?.hideLoadingView()
            let mySpotMasterDetail = MySpotMasterDetail.with(json: apiResponse.data)
            self?.masterView?.setContent(mySpotMasterDetail: mySpotMasterDetail)
            }, failure: { [weak self] (error) in
                self?.masterView?.hideLoadingView()
                self?.masterView?.showEmptyView()
        })
    }
}
