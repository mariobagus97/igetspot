////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotOrderActiveView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(orderActiveArray : [MySpotOrderActive])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? )
}

class MySpotOrderActivePresenter: MKPresenter {
    private weak var orderActiveView: MySpotOrderActiveView?
    var mySpotService: MySpotOrderService?
    
    override init() {
        super.init()
        mySpotService = MySpotOrderService()
    }
    
    func attachview(_ view: MySpotOrderActiveView) {
        self.orderActiveView = view
    }
    
    func getOrderActiveList() {
        orderActiveView?.showLoadingView()
        mySpotService?.requestOrderActiveList(success: { [weak self] (apiResponse) in
            self?.orderActiveView?.hideLoadingView()
            let orderActiveArray = MySpotOrderActive.with(jsons: apiResponse.data.arrayValue)
            if orderActiveArray.isEmpty {
                self?.handleNoOrderList()
            } else {
                self?.orderActiveView?.setContent(orderActiveArray: orderActiveArray)
            }
            }, failure: { [weak self] (error) in
                self?.orderActiveView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoOrderList()
                } else {
                    self?.orderActiveView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoOrderList() {
        orderActiveView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of order active", comment: ""),
                                       description: NSLocalizedString("", comment: ""), buttonTitle: nil, emptyCellButtonType:.start)
    }
}
