//
//  MasterDetailReviewListCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Cosmos

class MasterDetailReviewListCell : MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userReviewImageView: UIImageView!
    @IBOutlet weak var rateGivenCosmosView: CosmosView!
    @IBOutlet weak var dateRateGivenLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var clientFromLabel: UILabel!
    @IBOutlet weak var userReviewtextView: UILabel!
    
    var reviewList : ReviewList!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userReviewImageView.setRounded()
        
        userReviewImageView.isSkeletonable = true
        rateGivenCosmosView.isSkeletonable = true
        dateRateGivenLabel.isSkeletonable = true
        userNameLabel.isSkeletonable = true
        clientFromLabel.isSkeletonable = true
        userReviewtextView.isSkeletonable = true
    }
    
    func setContent(reviewList: ReviewList){
        self.reviewList = reviewList
        rateGivenCosmosView.rating = reviewList.rate ?? 0.0
        
        userNameLabel.text = reviewList.userName
        dateRateGivenLabel.text = reviewList.reviewDate
        clientFromLabel.text = reviewList.userHistory
        userReviewtextView.text = reviewList.review
        userReviewImageView.loadIGSImage(link: reviewList.imageUrl ?? "", placeholderImage: R.image.userPlacaholder())
    }
}
