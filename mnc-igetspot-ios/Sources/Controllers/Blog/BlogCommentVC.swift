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

protocol BlogCommentVCDelegate {
    func closeVC()
    func goToAddPage()
    
}

class BlogCommentVC : MKViewController {
    
    var delegate : BlogCommentVCDelegate!
    
    var blogCommentPage: BlogCommentPage!
    
    var emptyLoadingView = EmptyLoadingView()
    
    var presenter = BlogCommentPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        presenter.attachview(self)
        getAllBlogs()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    
    func addView() {
        blogCommentPage = UINib(nibName: "BlogCommentPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BlogCommentPage
        blogCommentPage.delegate = self
        
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
    
    func setContent(commentList : [BlogComment]){
        blogCommentPage.setResultContent(list: commentList)
    }
    
    // MARK: - Private Funtions
    private func getAllBlogs() {
        self.presenter.getlist(blogId: "123")
    }
    
}


extension BlogCommentVC : BlogCommentPageDelegate{
    func hidePage() {
        self.delegate?.closeVC()
    }
    
    func addCommentPage() {
        self.delegate?.goToAddPage()
    }
}
