//
//  BlogDetailVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/14/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit
import FloatingPanel
import SwiftMessages

class BlogDetailVC : MKViewController {
    
    var mPresenter = BlogDetailPresenter()
    var headerView = BlogDetailHeaderView()
    var contentView = BlogDetailContentView()
    var emptyLoadingView = EmptyLoadingView()
    var anotherTopicView = BlogAnotherTopicView()
//    var footerView = UINib(nibName: "BlogFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BlogFooterView
    var imageContainerView = UIView()
    var scrollView = UIScrollView()
    var blog: Whatson?
    var blogArray: [Whatson]?
    private let backButton = UIButton(type: .custom)
    
    var commentPanelVC : FloatingPanelController!
    var morePanelVC : FloatingPanelController!
    let backwhite = UIView()
    let bordernav = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        disableSwipeMenuView()
        initSwipeToBack()
        setupNavigationBar()
        addViews()
        setupConstraints()
        mPresenter.attachview(self)
        setHeaderContent()
        setAnotherTopicContent()
        getBlogDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentTransparentNavigationBar()
        setStatusBarStyle(.lightContent)
        setNavigationBarTitleColor(color: UIColor.white)
        scrollViewDidScroll(self.scrollView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
        setNavigationBarTitleColor(color: UIColor.black)
        setStatusBarStyle(.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideBorder()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Happening Now", comment: ""))
        setupBarButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//
////        scrollView.scrollIndicatorInsets =
//        DispatchQueue.main.async {[weak self] in
//            //** We want the scroll indicators to use all safe area insets
            if #available(iOS 11.0, *) {
                self.scrollView.scrollIndicatorInsets = (self.view.safeAreaInsets)
                //** But we want the actual content inset to just respect the bottom safe inset
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (self.view.safeAreaInsets.bottom), right: 0)

            }
//        }
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Private Functions
    private func setupBarButtonItem() {
        backButton.setImage(R.image.backWhite(), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func getBlogDetail() {
        if let blog = self.blog, let detailId = blog.id {
            self.mPresenter.getDetail(detailId: detailId)
        }
    }
    
    private func addViews() {
        
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(contentView)
        scrollView.addSubview(anotherTopicView)
        scrollView.addSubview(emptyLoadingView)
        
//        view.addSubview(footerView)
        
        emptyLoadingView.delegate = self
        emptyLoadingView.alpha = 0.0
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(headerView.snp.width).multipliedBy(0.6)
        }
        
        headerView.snp.makeConstraints { make in
            make.left.right.equalTo(imageContainerView)
            
            //** Note the priorities
            make.top.equalTo(view).priority(.high)
            
            //** We add a height constraint too
            make.height.greaterThanOrEqualTo(imageContainerView.snp.height).priority(.required)
            
            //** And keep the bottom constraint
            make.bottom.equalTo(imageContainerView.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(anotherTopicView.snp.top)
        }

//        anotherTopicView.alpha = 0.0
        anotherTopicView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
            make.height.equalTo(250)
        }
        
        scrollView.layoutIfNeeded()
        emptyLoadingView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(self.view.frame.height - imageContainerView.frame.height)
        }
        
//        footerView.delegate = self
//        footerView.snp.makeConstraints { (make) in
//            make.right.bottom.left.equalTo(view)
//            make.height.equalTo(view.frame.height / 10)
//        }
    }
    
    private func setHeaderContent() {
        if let blog = self.blog, let imageUrl = blog.imageUrl, let blogTitle = blog.title {
            headerView.setContent(withImageUrl: imageUrl, title: blogTitle)
        }
    }
    
    private func setAnotherTopicContent() {
        if let blogs = self.blogArray, blogs.count > 0 {
            anotherTopicView.setContent(withBlogs: blogs)
            anotherTopicView.delegate = self
        } else {
            anotherTopicView.snp.updateConstraints({ make in
                make.height.equalTo(0)
            })
        }
    }
    
    func onCommentPressed() {
        commentPanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        commentPanelVC?.surfaceView.cornerRadius = 8.0
        commentPanelVC?.surfaceView.shadowHidden = false
        commentPanelVC?.isRemovalInteractionEnabled = true
//        commentPanelVC?.delegate = self
        
        let commentVC = BlogCommentVC()
        commentVC.delegate = self
        commentPanelVC?.set(contentViewController: commentVC)
        
        
        self.present(commentPanelVC!, animated: true, completion: nil)
    }
    
    func onMorePressed() {
        morePanelVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        morePanelVC?.surfaceView.cornerRadius = 8.0
        morePanelVC?.surfaceView.shadowHidden = false
        morePanelVC?.isRemovalInteractionEnabled = true
        morePanelVC?.delegate = self
        
        let moreVC = BlogMoreVC()
//        moreVC.delegate = self
        morePanelVC?.set(contentViewController: moreVC)
        
        
        self.present(morePanelVC!, animated: true, completion: nil)
    }
    
    
    private func hideCommentVC() {
        if let commentPanelVC = self.commentPanelVC {
            commentPanelVC.dismiss(animated: true, completion: nil)
        }
    }
    
    private func hideMoreVC() {
        if let morePanelVC = self.morePanelVC {
            morePanelVC.dismiss(animated: true, completion: nil)
        }
    }
}

extension BlogDetailVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addBorder()
//        borderwhite.backgroundColor = Colors.inputTextGray
//        bgwhite.backgroundColor = .white
//        self.view.addSubview(bgwhite)
//        self.view.addSubview(border)
//        border.translatesAutoresizingMaskIntoConstraints = false
//        if #available(iOS 11.0, *) {
//            let guide = self.view.safeAreaLayoutGuide
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(guide)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(guide)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        } else {
//            bgwhite.snp.makeConstraints{ make in
//                make.left.top.right.equalTo(view)
//                make.height.equalTo(3)
//            }
//            border.snp.makeConstraints { make in
//                make.left.right.equalTo(view)
//                make.top.equalTo(bgwhite.snp.bottom)
//                make.height.equalTo(0.5)
//            }
//        }
        
        if (scrollView == self.scrollView) {
            let colorNavBar = UIColor.white
            let navbarChangePoint:CGFloat = 20
            let offsetY = scrollView.contentOffset.y
            if (offsetY > navbarChangePoint) {
                let alpha = min(1, 1 - ((navbarChangePoint + 64 - offsetY) / 64))
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(alpha))
                if (alpha < 0.5) {
                    setStatusBarStyle(.lightContent)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    setNavigationBarTitleColor(color: UIColor.white)
                    backButton.setImage(R.image.backWhite(), for: .normal)
                } else {
                    setStatusBarStyle(.default)
                    navigationController?.navigationBar.shadowImage = UIImage()
                    setNavigationBarTitleColor(color: UIColor.black)
                    backButton.setImage(R.image.backBlack(), for: .normal)
                    bgwhite.isHidden = false
                    border.isHidden = false
                }
            } else {
                self.navigationController?.navigationBar.lt_setBackgroundColor(backgroundColor: colorNavBar.withAlphaComponent(0))
                navigationController?.navigationBar.shadowImage = UIImage()
                backButton.setImage(R.image.backWhite(), for: .normal)
                setNavigationBarTitleColor(color: UIColor.white)
                
                bgwhite.isHidden = true
                border.isHidden = true
            }
        }
        
    }
    
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        hideBorder()
    }
}

// MARK: - EmptyLoadingViewDelegate
extension BlogDetailVC: EmptyLoadingViewDelegate {
    
    func errorTryAgainButtonDidClicked() {
        getBlogDetail()
    }
}

// MARK: - BlogAnotherTopicViewDelegate
extension BlogDetailVC: BlogAnotherTopicViewDelegate {
    
    func seeAllBlogDidClicked() {
        self.navigationController?.pushViewController(BlogArchiveTVC(), animated: true)
    }
    
    func anotherTopicDidClicked(withBlog blog: Whatson, blogArray: [Whatson]?) {
        let blogDetailVC = BlogDetailVC()
        blogDetailVC.blog = blog
        blogDetailVC.blogArray = blogArray
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
    }
}



//extension BlogDetailVC : BlogFooterViewDelegate {
//    func onShareSelected() {
//        //
//    }
//
//    func onMoreSelected() {
//        onMorePressed()
//    }
//
//    func onCommentSelected(){
//        onCommentPressed()
//    }
//}

extension BlogDetailVC : BlogCommentVCDelegate {
    func closeVC() {
        hideCommentVC()
    }
    
    func goToAddPage() {
        hideCommentVC()
         if (TokenManager.shared.isLogin()) {
            self.navigationController?.pushViewController(BlogAddCommentVC(), animated: true)
         } else {
            self.goToLoginScreen()
        }
    }

}

extension BlogDetailVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

extension BlogDetailVC : BlogDetailView {
    func showLoading() {
        //        footerView.isHidden = true
        scrollView.isScrollEnabled = false
        emptyLoadingView.alpha = 1.0
        emptyLoadingView.showLoadingView()
    }
    
    func hideLoading() {
        //        footerView.isHidden = false
        emptyLoadingView.alpha = 0.0
    }
    
    func showErrorMessage(_ message: String) {
        scrollView.isScrollEnabled = false
        emptyLoadingView.setEmptyErrorContent(withMessage: message, buttonTitle: NSLocalizedString("Try Again", comment: ""), forDisplay: .subview)
    }
    

    func setContent(blog: Whatson) {
        scrollView.isScrollEnabled = true
        contentView.setContent(withBlog: blog)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        //        anotherTopicView.alpha = 1.0
    }
    
}
