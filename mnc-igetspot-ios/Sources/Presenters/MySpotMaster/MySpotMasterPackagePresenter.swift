////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterPackageView:class {
    func showLoadingView()
    func showEmptyView(withMessage message:String)
    func setContent(packageLists : [MySpotPackages])
    func showErrorView(withMessage message:String)
}

class MySpotMasterPackagePresenter: MKPresenter {
    private weak var masterView: MySpotMasterPackageView?
    private var masterService: MySpotMasterDetailService?
    
    override init() {
        super.init()
        masterService = MySpotMasterDetailService()
    }
    
    func attachview(_ view: MySpotMasterPackageView) {
        self.masterView = view
    }
    
    func getDetailPackage(forMasterId masterId: String) {
        masterView?.showLoadingView()
        masterService?.requestMySpotPackages(masterId: masterId, success: { [weak self] (apiResponse) in
            let packagesArray = MySpotPackages.with(jsons: apiResponse.data.arrayValue)
            if packagesArray.count == 0 {
                self?.masterView?.showEmptyView(withMessage: NSLocalizedString("You don't have any package", comment: ""))
            } else {
                self?.masterView?.setContent(packageLists: packagesArray)
            }
            }, failure:  { [weak self] (error) in
                if error.statusCode == 400 {
                    self?.masterView?.showEmptyView(withMessage: NSLocalizedString("You don't have any package", comment: ""))
                } else {
                     self?.masterView?.showErrorView(withMessage: StringConstants.MessageErrorAPI.tryAgainMessage)
                }
        })
    }
}
