////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol MySpotBalanceView: class {
    func showLoadingView()
    func hideLoadingView()
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func setContent(mySpotBalance:MySpotBalance)
}

class MySpotBalancePresenter: MKPresenter {
    
    weak var view: MySpotBalanceView?
    private var profileService: ProfileService?
    
    override init() {
        super.init()
        profileService = ProfileService()
    }
    
    func attachview(_ view: MySpotBalanceView) {
        self.view = view
    }
    
    func getBalanceDetail() {
        view?.showLoadingView()
        profileService?.requestUserBalance(success: { [weak self] (apiResponse) in
            self?.view?.hideLoadingView()
            let dataJSON = apiResponse.data
            self?.parseResponse(withJSON: dataJSON)
            
            }, failure: { [weak self] (error) in
                self?.view?.hideLoadingView()
                if error.statusCode == 400 {
                    let dataJSON = error.userInfo["data"]
                    self?.parseResponse(withJSON: dataJSON)
                } else {
                    self?.view?.showEmptyView(withMessage: NSLocalizedString("Oops, something went wrong", comment: ""), description: error.message, buttonTitle: NSLocalizedString("Try Again", comment: ""), emptyCellButtonType: .error)
                }
        })
    }
    
    func parseResponse(withJSON dataJSON:JSON) {
        let mySpotBalance = MySpotBalance.with(json: dataJSON)
        view?.setContent(mySpotBalance: mySpotBalance)
    }
}
