////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol ReviewAndConfirmDelegate:class {
    func showReviewLoadingHUD()
    func hideReviewLoadingHUD()
    func handleReviewSuccess()
    func showMessageError(message:String)
}

class ReviewAndConfirmPresenter: MKPresenter {
    private weak var reviewView: ReviewAndConfirmDelegate?
    var transactionService: TransactionService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: ReviewAndConfirmDelegate) {
        self.reviewView = view
    }
    
    func postRatingOrder(masterId:String, orderId:String, packageId:String, serviceQuality:Int, timelinessRating:Int, qualityRating:Int, comment:String) {
        reviewView?.showReviewLoadingHUD()
        transactionService?.requestPostRating(masterId: masterId, orderId: orderId, packageId: packageId, serviceQuality:serviceQuality, timelinessRating:timelinessRating, qualityRating:qualityRating, comment: comment, success: { [weak self] (apiResponse) in
            self?.reviewView?.hideReviewLoadingHUD()
            self?.reviewView?.handleReviewSuccess()
            }, failure: { [weak self] (error) in
                self?.reviewView?.hideReviewLoadingHUD()
                self?.reviewView?.showMessageError(message: error.message)
        })
    }
}
