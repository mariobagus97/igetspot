//
//  ContactUsPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol ContactUsPageDelegate:class {
    func closeContactUs()
}

class ContactUsPage: UIView {
    
    @IBOutlet weak var messageTextView: KMPlaceholderTextView!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutMessage: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewwidth: NSLayoutConstraint!
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    
    weak var delegate: ContactUsPageDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        layoutMessage.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
        containerView.makeItRounded(width: 0.0, borderColor: UIColor.clear.cgColor, cornerRadius: 10)
    }
    
    func setSize(height: CGFloat, width: CGFloat){
        viewwidth.constant = width
        viewheight.constant = height
        layoutIfNeeded()
    }
    
    @IBAction func onHidePressed(_ sender: Any) {
        delegate?.closeContactUs()
    }
    
}
