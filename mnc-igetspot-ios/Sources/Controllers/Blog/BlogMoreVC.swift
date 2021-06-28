//
//  BlogMoreVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/13/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class BlogMoreVC : MKViewController {
    
//    var delegate : BlogMoreVCDelegate!
    var blogMorePage : BlogMorePage!
    var emptyLoadingView = EmptyLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    
    func addView() {
        blogMorePage = UINib(nibName: "BlogMorePage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BlogMorePage
//        blogMorePage.delegate = self
        
        self.view.addSubview(blogMorePage)
        blogMorePage.snp.makeConstraints { (make) in
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

extension BlogMoreVC : BlogMorePageDelegate {
    
    func didHidepressed(){
        
    }
    
    func didSharePressed(){
        
    }
    
    func didLikePressed(){
        
    }
    
    func didReportPressed(){
        
    }
    
    func didCopyPressed(){
        
    }
    
    func didSaveImagePressed(){
        
    }
}
