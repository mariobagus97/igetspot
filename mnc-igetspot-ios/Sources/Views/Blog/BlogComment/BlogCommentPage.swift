//
//  BlogCommentPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlogCommentPageDelegate {
    func addCommentPage()
    func hidePage()
}

class BlogCommentPage : UIView {
    
    var delegate : BlogCommentPageDelegate!

    @IBOutlet weak var commentTableView: BlogCommentTableView!
    
    var section : MKTableViewSection!
    var blogCommentCell : BlogCommentCell!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        commentTableView.cellDelegate = self
//        setupView()
    }
    
    @IBAction func onHidePressed(_ sender: Any) {
        self.delegate?.hidePage()
    }
    
    func setResultContent(list: [BlogComment]){
        commentTableView.setResultContent(list: list)
        commentTableView.contentView.reloadData()
        commentTableView.contentView.tableView.setNeedsLayout()
        commentTableView.contentView.tableView.layoutIfNeeded()
        tableHeight.constant = commentTableView.contentView.tableView.contentSize.height
        commentTableView.setNeedsLayout()
        commentTableView.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
}

extension BlogCommentPage : BlogCommentTableViewDelegate {
    func didAddComment() {
        self.delegate?.addCommentPage()
    }
    
}
