//
//  BlogFooterView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/8/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlogFooterViewDelegate {
    func onCommentSelected()
    func onShareSelected()
    func onMoreSelected()
}

class BlogFooterView : UIView {
    
    var delegate : BlogFooterViewDelegate!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var moreView: UIImageView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGesture()
    }
    
    func addGesture(){
        commentsLabel.isUserInteractionEnabled = true
        commentsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentSelected(_:))))
        
        moreView.isUserInteractionEnabled = true
        moreView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMoreSelected(_:))))
    }
    
    @objc func onCommentSelected(_ sender: UITapGestureRecognizer){
        self.delegate?.onCommentSelected()
    }
    
    @objc func onMoreSelected(_ sender: UITapGestureRecognizer){
        self.delegate?.onMoreSelected()
    }
}
