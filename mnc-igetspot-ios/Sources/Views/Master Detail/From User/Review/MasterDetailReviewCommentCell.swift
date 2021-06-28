//
//  MasterDetailReviewCommentCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung.k1 All rights reserved.
//

import UIKit

class MasterDetailReviewCommentCell : MKTableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var commentReviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        userProfileImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius :userProfileImageView.bounds.height / 2)
        commentReviewTextView.makeItRounded(width: 0.5, borderColor: UIColor.rgb(red: 142, green: 142, blue: 147, alpha: 0.4).cgColor, cornerRadius: 5)
    }
    
}

/*
 "uuid": "9c964300-f591-4573-b17b-b3c73385d2fd",
 "email": "destantifw@yahoo.com",
 "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDI3Nzg1NDUsImlzcyI6ImRlc3RhbnRpZndAeWFob28uY29tIn0.CsREXiuuM41opSXx5JNeNA1ZdNq_Ph5NqXvsYut1G7I"
 */
