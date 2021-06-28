////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotFinishYourOrderDelegate:class {
    func showOrderLoadingHUD()
    func hideOrderLoadingHUD()
    func handleFinishOrderSuccess()
    func showMessageError(message:String)
}

class MySpotFinishYourOrderPresenter: MKPresenter {
    private weak var finishView: MySpotFinishYourOrderDelegate?
    var mySpotService: MySpotOrderService?
    
    override init() {
        super.init()
        mySpotService = MySpotOrderService()
    }
    
    func attachview(_ view: MySpotFinishYourOrderDelegate) {
        self.finishView = view
    }
    
    func requestFinishOrder(orderId:String, invoiceID:String, packageID:String, image:UIImage) {
        finishView?.showOrderLoadingHUD()
        mySpotService?.requestCompleteOrder(orderId: orderId,invoiceId: invoiceID,packageId: packageID , image: image, success: { [weak self] (apiResponse) in
            self?.finishView?.hideOrderLoadingHUD()
            self?.finishView?.handleFinishOrderSuccess()
            }, failure: { [weak self] (error) in
                self?.finishView?.hideOrderLoadingHUD()
                self?.finishView?.showMessageError(message: error.message)
        })
    }
}
