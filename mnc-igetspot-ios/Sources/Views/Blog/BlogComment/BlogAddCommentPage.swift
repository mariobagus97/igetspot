//
//  BlogAddCommentPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class BlogAddCommentPage : UIView {
    
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getCommentSubject() -> String {
        if let subject = subjectField.text {
            return subject
        }
        return ""
    }
    
    func getCommentContent() -> String {
        if let content = commentTextView.text {
           return content
        }
        return ""
    }
    
}
