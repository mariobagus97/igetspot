////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol OrderDetailView:class {
    func showOrderLoadingHUD()
    func hideOrderLoadingHUD()
    func handleOrderSuccess()
    func showMessageError(message:String)
}

class OrderDetailPresenter: MKPresenter {
    private weak var orderDetailView: OrderDetailView?
    private var orderService: OrderService?
    
    override init() {
        super.init()
        orderService = OrderService()
    }
    
    func attachview(_ view: OrderDetailView) {
        self.orderDetailView = view
    }
    
    func requestOrderAdd(packageId:String, address:String, latlong:String, date:String, time:String, notes:String) {
        orderDetailView?.showOrderLoadingHUD()
        let parameters = ["package_id":packageId,
                          "date":date,
                          "time":time,
                          "address":address,
                          "location":latlong,
                          "notes":notes]
        orderService?.requestOrderDraftAdd(parameters: parameters, success: { [weak self] (apiResponse) in
            self?.orderDetailView?.hideOrderLoadingHUD()
            self?.orderDetailView?.handleOrderSuccess()
            }, failure: { [weak self] (error) in
                self?.orderDetailView?.hideOrderLoadingHUD()
                self?.orderDetailView?.showMessageError(message: error.message)
        })
    }
}
