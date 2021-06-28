//
//  BlogCommentVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

protocol BlogAddCommentVCDelegate {
    func addComment(comment: BlogComment)
}

class BlogAddCommentVC : MKViewController {
    
    var contentSection = MKTableViewSection()
    var blogCommentPage : BlogAddCommentPage!
    var emptyLoadingView = EmptyLoadingView()
    
    var delegate : BlogAddCommentVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        
        setupNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
        navigationController?.presentIGSNavigationBar()
    }

    override func setupNavigationBar() {
        setupNavigationBarTitle("Add Comment")
        setupRightBarButtonItems()
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func setupRightBarButtonItems() {
        let btnSend = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 25))
        btnSend.setTitle( "Send", for: .normal)
        btnSend.backgroundColor = UIColor.white
        btnSend.setTitleColor(Colors.blueTwo, for: .normal)
        btnSend.titleLabel?.font = R.font.barlowMedium(size: 14)
        btnSend.layer.cornerRadius = 4.0
        btnSend.layer.masksToBounds = true
        
        let sendItem = UIBarButtonItem(customView: btnSend)
        self.navigationItem.rightBarButtonItem  = sendItem
    }
    
    @objc func sendPressed(){
        let subject = blogCommentPage.getCommentSubject()
        let content = blogCommentPage.getCommentContent()
        
        if subject != "" && content != "" {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.showErrorMessageBanner(NSLocalizedString("You must add subject and comment", comment: ""))
        }
    }
    
    func addView() {
        blogCommentPage = UINib(nibName: "BlogAddCommentPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BlogAddCommentPage
        //        blogCommentPage.delegate = self
        
        self.view.addSubview(blogCommentPage)
        blogCommentPage.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
        //        scrollView.addSubview(blogCommentPage)
    }
    
    
    // MARK: - Publics Functions
    func showLoadingView() {
        
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoadingView() {
        emptyLoadingView.alpha = 0.0
    }
    
   
}
