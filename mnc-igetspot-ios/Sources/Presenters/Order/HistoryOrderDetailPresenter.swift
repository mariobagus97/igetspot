////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol HistoryOrderDetailView:class {
    func showLoadingView()
    func hideLoadingView()
    func setContent(orderHistoryDetail:OrderHistoryDetail)
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? )
    func showOrderLoadingHUD()
    func hideOrderLoadingHUD()
    func goToOrderDetail(packageId: String, orderDetail:OrderDetail)
    func showErrorMessage(message:String)
}

class HistoryOrderDetailPresenter: MKPresenter {
    private weak var historyDetailView: HistoryOrderDetailView?
    private var orderService: OrderService?
    
    override init() {
        super.init()
        orderService = OrderService()
    }
    
    func attachview(_ view: HistoryOrderDetailView) {
        self.historyDetailView = view
    }
    
    func getHistoryOrderDetail(masterId:String,orderId:String,packageID:String) {
        historyDetailView?.showLoadingView()
        orderService?.requestHistoryOrderDetail(masterId: masterId,orderID: orderId,packageID: packageID, success: { [weak self] (apiResponse) in
            self?.historyDetailView?.hideLoadingView()
            let orderHistoryDetail = OrderHistoryDetail.with(json: apiResponse.data)
            self?.historyDetailView?.setContent(orderHistoryDetail: orderHistoryDetail)
            }, failure: { [weak self] (error) in
                self?.historyDetailView?.hideLoadingView()
                self?.historyDetailView?.showEmptyView(withMessage: "\(error.message)", description: nil,
                    buttonTitle: NSLocalizedString("Try Again", comment: ""),
                    emptyCellButtonType:.error)
        })
    }
    
    func requestOrderPackage(packageId:String) {
        historyDetailView?.showOrderLoadingHUD()
        orderService?.requestOrderDraft(packageId: packageId, success: { [weak self] (apiResponse) in
            self?.historyDetailView?.hideOrderLoadingHUD()
            let orderDetail = OrderDetail.with(json: apiResponse.data)
            self?.historyDetailView?.goToOrderDetail(packageId: packageId, orderDetail: orderDetail)
            }, failure: { [weak self] (error) in
                self?.historyDetailView?.hideOrderLoadingHUD()
                self?.historyDetailView?.showErrorMessage(message:error.message)
        })
    }
}
