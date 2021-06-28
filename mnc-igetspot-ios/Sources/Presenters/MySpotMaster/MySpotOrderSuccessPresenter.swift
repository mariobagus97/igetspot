////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

protocol MySpotOrderSuccessView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(orderSuccessArray : [MySpotOrderSuccess])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
}

class MySpotOrderSuccessPresenter: MKPresenter {
    private weak var orderSuccessView: MySpotOrderSuccessView?
    var mySpotService: MySpotOrderService?
    
    override init() {
        super.init()
        mySpotService = MySpotOrderService()
    }
    
    func attachview(_ view: MySpotOrderSuccessView) {
        self.orderSuccessView = view
    }
    
    func getOrderSuccessList() {
        orderSuccessView?.showLoadingView()
        mySpotService?.requestOrderSuccessList(success: { [weak self] (apiResponse) in
            self?.orderSuccessView?.hideLoadingView()
            let orderSuccessArray = MySpotOrderSuccess.with(jsons: apiResponse.data.arrayValue)
            if orderSuccessArray.isEmpty {
                self?.handleNoOrderList()
            } else {
                self?.orderSuccessView?.setContent(orderSuccessArray: orderSuccessArray)
            }
            }, failure: { [weak self] (error) in
                self?.orderSuccessView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoOrderList()
                } else {
                    self?.orderSuccessView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoOrderList() {
        orderSuccessView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of order success", comment: ""),
                                        description: NSLocalizedString("", comment: ""), buttonTitle: nil, emptyCellButtonType:.start)
    }
}
