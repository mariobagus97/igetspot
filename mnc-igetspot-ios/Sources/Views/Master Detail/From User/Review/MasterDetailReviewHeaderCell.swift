//
//  MasterDetailReviewHeaderCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Cosmos

protocol MasterDetailReviewHeaderCellDelegate {
    func showRating(withSelectedRating rating:Int)
}

class MasterDetailReviewHeaderCell : MKTableViewCell {
    
    @IBOutlet weak var reviewFromLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var serviceRateCosmosView: CosmosView!
    @IBOutlet weak var timelinessCosmosView: CosmosView!
    @IBOutlet weak var qualityCosmosView: CosmosView!
    @IBOutlet weak var filterRatingView: FilterRatingView!
    @IBOutlet weak var containerRatingInfoStackView: UIStackView!
    @IBOutlet weak var serviceQualityStackView: UIStackView!
    @IBOutlet weak var timelinessStackView: UIStackView!
    @IBOutlet weak var qualityStackView: UIStackView!
    @IBOutlet weak var heightContainerRatingConstraint: NSLayoutConstraint!
    
    var ratingDetail : RatingDetail!
    var selectedButton : UIButton?
    var delegate: MasterDetailReviewHeaderCellDelegate!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        serviceQualityStackView.isSkeletonable = true
        timelinessStackView.isSkeletonable = true
        qualityStackView.isSkeletonable = true
        
        filterRatingView.delegate = self
        
    }
    
    // MARK: - Public Functions
    func setContent(ratingDetail: RatingDetail){
        self.ratingDetail = ratingDetail
        
        if let totalReviewer = ratingDetail.totalReview, let totalReviewInt = Int(totalReviewer), totalReviewInt > 0 {
            reviewFromLabel.text = "From \(totalReviewInt) Users"
            rateLabel.text = String(format: "%.1f", ratingDetail.averageRating ?? 0.0)
            heightContainerRatingConstraint.constant = 60
        } else {
            reviewFromLabel.text = "No Review"
            rateLabel.text = "0"
            heightContainerRatingConstraint.constant = 0
        }
        self.layoutIfNeeded()
        serviceRateCosmosView.rating = ratingDetail.serviceQualityRating ?? 0.0
        timelinessCosmosView.rating =  ratingDetail.timelinessRating ?? 0.0
        qualityCosmosView.rating = ratingDetail.qualityRating ?? 0.0
    }
    
    func showLoadingView() {
        containerRatingInfoStackView.showAnimatedGradientSkeleton()
        serviceQualityStackView.showAnimatedGradientSkeleton()
        timelinessStackView.showAnimatedGradientSkeleton()
        qualityStackView.showAnimatedGradientSkeleton()
        filterRatingView.alpha = 0
        
    }
    
    func hideLoadingView() {
        containerRatingInfoStackView.hideSkeleton()
        serviceQualityStackView.hideSkeleton()
        timelinessStackView.hideSkeleton()
        qualityStackView.hideSkeleton()
        filterRatingView.alpha = 1
    }
    
    // MARK: - Actions
    
    
    // MARK: - Private Function
    
}


extension MasterDetailReviewHeaderCell : FilterRatingViewDelegate {
    func filterRatingDidSelect(selectedRating rating: Int) {
        delegate.showRating(withSelectedRating: rating)
    }
}
