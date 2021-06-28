//
//  BlogCommentPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlogMorePageDelegate {
    func didHidepressed()
    func didSharePressed()
    func didLikePressed()
    func didReportPressed()
    func didCopyPressed()
    func didSaveImagePressed()
}


class BlogMorePage : UIView {
    
//    var delegate : BlogCommentPageDelegate!
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var copyView: UIView!
    @IBOutlet weak var saveImageView: UIView!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
    }
    
    @IBAction func onHidePressed(_ sender: Any) {
    }
    
}
