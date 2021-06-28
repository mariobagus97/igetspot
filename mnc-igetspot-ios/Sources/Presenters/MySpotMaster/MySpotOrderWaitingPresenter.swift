////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

protocol MySpotOrderWaitingView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(orderWaitingArray : [MySpotOrderWaiting])
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
}

class MySpotOrderWaitingPresenter: MKPresenter {
    private weak var orderWaitingView: MySpotOrderWaitingView?
    var mySpotService: MySpotOrderService?


    override init() {
        super.init()
        mySpotService = MySpotOrderService()
    }
    
    func attachview(_ view: MySpotOrderWaitingView) {
        self.orderWaitingView = view
    }
    
    func getOrderWaitingList() {
        orderWaitingView?.showLoadingView()
        mySpotService?.requestOrderWaitingList(success: { [weak self] (apiResponse) in
            self?.orderWaitingView?.hideLoadingView()
            let orderWaitingArray = MySpotOrderWaiting.with(jsons: apiResponse.data.arrayValue)
            if orderWaitingArray.isEmpty {
                self?.handleNoOrderList()
            } else {
                self?.orderWaitingView?.setContent(orderWaitingArray: orderWaitingArray)
            }
            }, failure: { [weak self] (error) in
                self?.orderWaitingView?.hideLoadingView()
                if error.statusCode == 400 {
                    self?.handleNoOrderList()
                } else {
                    self?.orderWaitingView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                        buttonTitle: NSLocalizedString("Try Again", comment: ""),
                        emptyCellButtonType:.error)
                }
        })
    }
    
    func handleNoOrderList() {
        orderWaitingView?.showEmptyView(withMessage: NSLocalizedString("You don’t have any list of order request", comment: ""),
                                        description: NSLocalizedString("", comment: ""),
                                        buttonTitle: nil,
                                        emptyCellButtonType:.start)
    }
}
