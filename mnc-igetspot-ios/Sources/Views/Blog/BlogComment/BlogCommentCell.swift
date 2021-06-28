//
//  BlogCommentCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/8/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlogCommentCellDelegate {
    func onAddCommentPressed()
}

class BlogCommentCell : MKTableViewCell {
    
    @IBOutlet weak var commentSubject: UILabel!
    @IBOutlet weak var commentFromLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var addCommentLabel: UILabel!
    
    var delegate: BlogCommentCellDelegate?
    var comment: BlogComment!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addGesture()
    }
    
    func setContent(comment: BlogComment){
        self.comment = comment
        
        commentSubject.text = comment.commentSubject
        commentFromLabel.text = comment.userName
        commentTimeLabel.text = comment.date
        commentContentLabel.text = comment.comment
//        addC
    }
    
    func addGesture(){
        addCommentLabel.isUserInteractionEnabled = true
        addCommentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentSelected(_:))))
    }
    
    @objc func onCommentSelected(_ sender: UITapGestureRecognizer){
        self.delegate?.onAddCommentPressed()
    }
    
}
