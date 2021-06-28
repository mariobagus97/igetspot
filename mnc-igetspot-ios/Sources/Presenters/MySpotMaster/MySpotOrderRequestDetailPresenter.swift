//
//  MySpotOrderRequestDetailPresenter.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 25/03/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotOrderRequestDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func showOrderLoadingHUD()
    func hideOrderLoadingHUD()
    func setContent(orderRequestDetail:MySpotOrderRequestDetail)
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?)
    func handleConfirmDeclinedOrder(isConfirm:Bool)
    func showMessageError(message:String)
}

class MySpotOrderRequestDetailPresenter: MKPresenter {
    private weak var orderDetailView: MySpotOrderRequestDetailView?
    var mySpotService: MySpotOrderService?
    
    override init() {
        super.init()
        mySpotService = MySpotOrderService()
    }
    
    func attachview(_ view: MySpotOrderRequestDetailView) {
        self.orderDetailView = view
    }
    
    func getOrderDetail(packageId:String, orderId:String) {
        orderDetailView?.showLoadingView()
        mySpotService?.requestOrderDetail(orderId: orderId, packageId: packageId, success: { [weak self] (apiResponse) in
            self?.orderDetailView?.hideLoadingView()
            let orderRequestDetail = MySpotOrderRequestDetail.with(json: apiResponse.data)
            self?.orderDetailView?.setContent(orderRequestDetail: orderRequestDetail)
            }, failure: { [weak self] (error) in
                self?.orderDetailView?.hideLoadingView()
                self?.orderDetailView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                    buttonTitle: NSLocalizedString("Try Again", comment: ""),
                    emptyCellButtonType:.error)
        })
    }
    
    func confirmOrder(isConfirm:Bool, packageId:String, orderId:String) {
        orderDetailView?.showOrderLoadingHUD()
        mySpotService?.requestOrderConfirmation(orderId:orderId, packageId:packageId, isConfirmed:isConfirm, success: { [weak self] (apiResponse) in
            self?.orderDetailView?.hideOrderLoadingHUD()
            self?.orderDetailView?.handleConfirmDeclinedOrder(isConfirm: isConfirm)
            }, failure: { [weak self] (error) in
                self?.orderDetailView?.hideOrderLoadingHUD()
                self?.orderDetailView?.showMessageError(message: error.message)
        })
    }
}
