//
//  BlogDetailTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 25/10/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//


import UIKit
import SnapKit
import FloatingPanel

class BlogDetailTVC : MKTableViewController {
    
    var blog: Whatson?
    var blogArray: [Whatson]?
    private let backButton = UIButton(type: .custom)
    
    var headerCell : BlogDetailHeaderCell!
    var contentCell : BlogDetailContentCell!
    var blogContent : BlogContentLabel!
    var anotherTopicCell : BlogAnotherTopicListCell!
    
    var commentPanelVC : FloatingPanelController!
    var morePanelVC : FloatingPanelController!
    let backwhite = UIView()
    let bordernav = UIView()
    var contentSection = MKTableViewSection()
    var mPresenter = BlogDetailPresenter()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        disableSwipeMenuView()
//        initSwipeToBack()
        setupNavigationBar()
        mPresenter.attachview(self)
        getBlogDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.tableView.contentInset = UIEdgeInsets(top: -90, left: 0, bottom: 0, right: 0)
        navigationController?.presentTransparentNavigationBar()
        setStatusBarStyle(.lightContent)
        setNavigationBarTitleColor(color: UIColor.white)
        scrollViewDidScroll(self.contentView.tableView)
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
    
    
    override func registerNibs() {
        super.registerNibs()

        contentView.registeredCellIdentifiers.append(R.nib.blogDetailHeaderView.name)
        contentView.registeredCellIdentifiers.append(R.nib.blogDetailContentView.name)
        contentView.registeredCellIdentifiers.append(R.nib.blogContentLabel.name)
        contentView.registeredCellIdentifiers.append(R.nib.blogAnotherTopicView.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    
    func showEmptyView(withMessage message:String, description:String? = "", buttonTitle:String? = nil, emptyCellButtonType:EmtypCellButtonType? = .error) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    // MARK: - Private Funtions
    
    private func setupBarButtonItem() {
        backButton.setImage(R.image.backWhite(), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidClicked), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setHeaderContent() {
        createHeaderCell()
        if let blog = self.blog, let imageUrl = blog.imageUrl, let blogTitle = blog.title {
            headerCell.setContent(withImageUrl: imageUrl, title: blogTitle)
        }
        contentView.reloadData()
    }
    
    private func getBlogDetail() {
        if let blog = self.blog {
            self.mPresenter.getDetail(detailId: blog.id!)
        }
    }
    
    private func setAnotherTopicContent() {
        if let blogs = self.blogArray, blogs.count > 0 {
            createAnotherTopicCell()
            anotherTopicCell.setContent(withBlogs: blogs)
            anotherTopicCell.delegate = self
            contentView.reloadData()
            
            print("total rows \(contentSection.numberOfRows())")
        }
    }
    
    private func createHeaderCell() {
        headerCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogDetailHeaderView.name) as? BlogDetailHeaderCell
        contentSection.appendRow(cell: headerCell)
    }
    
    private func createContentCell(){
        contentCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogDetailContentView.name) as? BlogDetailContentCell
    }
    
    private func createContentLabelCell(){
        blogContent = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogContentLabel.name) as? BlogContentLabel
//        contentSection.appendRow(cell: blogContent)
    }
    
    private func createAnotherTopicCell() {
        anotherTopicCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogAnotherTopicView.name) as? BlogAnotherTopicListCell
        contentSection.appendRow(cell: anotherTopicCell)
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func addRows(){
        contentView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addBorder()
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


    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView){
        hideBorder()
    }
    
}

extension BlogDetailTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            self.getBlogDetail()
        }
    }
}


extension BlogDetailTVC : BlogDetailView {
    func setContent(blog: Whatson) {
        self.createContentCell()
        self.createContentLabelCell()
        self.contentCell.setContent(withBlog: blog)
        if let contentString = blog.detail {
            self.blogContent.setContent(contentString: contentString)
        }
        
        setHeaderContent()
        contentSection.appendRow(cell: contentCell)
        contentSection.appendRow(cell: blogContent)
        setAnotherTopicContent()
        contentView.reloadData()
    }
    
    func showLoading() {
        self.contentView.scrollEnabled(false)
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
        loadingCell.loadingIndicatorView.startAnimating()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
//        }
    }
    
    func hideLoading() {
        self.contentView.scrollEnabled(true)
        contentSection.removeAllRows()
        
    }
    
    func showErrorMessage(_ message: String) {
        self.showEmptyView(withMessage: message, buttonTitle: nil, emptyCellButtonType:.error)
    }
    
    
}

// MARK: - BlogAnotherTopicViewDelegate
extension BlogDetailTVC: BlogAnotherTopicViewDelegate {
    
    func seeAllBlogDidClicked() {
        self.navigationController?.pushViewController(BlogArchiveTVC(), animated: true)
    }
    
    func anotherTopicDidClicked(withBlog blog: Whatson, blogArray: [Whatson]?) {
        let blogDetailVC = BlogDetailTVC()
        blogDetailVC.blog = blog
        blogDetailVC.blogArray = blogArray
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
    }
}
