////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterReviewView:class {
    func showReviewListLoadingView()
    func hideReviewListLoadingView()
    func showReviewListEmptyView(withMessage message:String)
    func showRatingDetail(ratingDetail: RatingDetail)
}

class MySpotMasterReviewPresenter: MKPresenter {
    
    private weak var masterView: MySpotMasterReviewView?
    private var mySpotService: MySpotMasterDetailService?
    private var masterService: MasterService?
    
    override init() {
        super.init()
        mySpotService = MySpotMasterDetailService()
        masterService = MasterService()
    }
    
    func attachview(_ view: MySpotMasterReviewView) {
        self.masterView = view
    }
    
    func getMySpotReviewDetail() {
        masterView?.showReviewListLoadingView()
        mySpotService?.requestMySpotRatingAndReview(success: { [weak self] (apiResponse) in
            self?.masterView?.hideReviewListLoadingView()
            let ratingDetail = RatingDetail.with(json: apiResponse.data)
            self?.masterView?.showRatingDetail(ratingDetail: ratingDetail)
            }, failure: { [weak self] (error) in
                self?.masterView?.hideReviewListLoadingView()
                self?.masterView?.showReviewListEmptyView(withMessage: error.message)
        })
    }
}
