//
//  ResultSearchTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BlogCommentTableViewDelegate {
    func didAddComment()
}

class BlogCommentTableView : UIView, MKTableViewDelegate {
    
    var section : MKTableViewSection!
    var contentView: MKTableView!
    var blogCommentCell : BlogCommentCell!
    
    var cellDelegate : BlogCommentTableViewDelegate!
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Public Functions
    func setupView() {
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        contentView.tableView.isScrollEnabled = false
        self.addSubview(contentView)
        
        let topOffset:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 60 : 80
        
        contentView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createCommentCell()
    }
    
    func createSections() {
        section = MKTableViewSection()
        contentView.appendSection(section)
        
        contentView.reloadData()
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.blogCommentCell.name
            ])
    }
    
    func setResultContent(list: [BlogComment]){
        for item in list {
            createCommentCell()
            blogCommentCell.setContent(comment: item)
            section.appendRow(cell: blogCommentCell)
        }
        
    }
    
    private func createCommentCell(){
        blogCommentCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogCommentCell.name) as? BlogCommentCell
        blogCommentCell.delegate = self
    }
    
}

extension BlogCommentTableView : BlogCommentCellDelegate {
    
    func onAddCommentPressed(){
        self.cellDelegate.didAddComment()
    }
}
