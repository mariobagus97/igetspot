//
//  MasterDetailReviewPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol MasterDetailReviewView:class {
    func showReviewListLoadingView()
    func hideReviewListLoadingView()
    func showRatingDetail(ratingDetail: RatingDetail)
    func showReviewListEmptyView(withMessage message:String)
}

class MasterDetailReviewPresenter : MKPresenter {
    
    private weak var masterView: MasterDetailReviewView?
    private var masterService: MasterService?
    
    override init() {
        super.init()
        masterService = MasterService()
    }
    
    func attachview(_ view: MasterDetailReviewView) {
        self.masterView = view
    }
    
    func getReviewDetail(forMasterId masterId:String) {
        masterView?.showReviewListLoadingView()
        masterService?.requestMasterRatingAndReview(masterId: masterId, success: { [weak self] (apiResponse) in
            self?.masterView?.hideReviewListLoadingView()
            let ratingDetail = RatingDetail.with(json: apiResponse.data)
            self?.masterView?.showRatingDetail(ratingDetail: ratingDetail)
            }, failure: { [weak self] (error) in
                self?.masterView?.hideReviewListLoadingView()
                self?.masterView?.showReviewListEmptyView(withMessage: error.message)

        })
    }
}
