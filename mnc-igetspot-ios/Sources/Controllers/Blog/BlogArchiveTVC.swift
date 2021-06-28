//
//  BlogArchiveTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/27/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//
import UIKit
import SnapKit

class BlogArchiveTVC : MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var presenter = BlogArchivePresenter()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter.attachview(self)
        getAllBlogs()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Archive Blogs", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.blogListCell.name)
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
    
    func addBlog(blog : Whatson) {
        let blogCell = createBlogCell()
        blogCell.delegate = self
        blogCell.setContent(blog: blog)
        contentSection.appendRow(cell: blogCell)
    }
    
    // MARK: - Private Funtions
    private func getAllBlogs() {
        self.presenter.getList()
    }
    
    private func createBlogCell() -> BlogListCell {
        let blogCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.blogListCell.name) as? BlogListCell
        return blogCell!
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
    
}

extension BlogArchiveTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            self.getAllBlogs()
        }
    }
}

extension BlogArchiveTVC: BlogListCellDelegate {
    func blogListDidClicked(atItem blog: Whatson) {
        let blogDetailVC = BlogDetailTVC()
        blogDetailVC.blog = blog
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
    }

}

extension BlogArchiveTVC : BlogArchiveView {
    func showErrorMessage(_ message: String) {
        //
    }
    
    func showEmpty(_ message: String) {
        self.showEmptyView(withMessage: message, buttonTitle: nil, emptyCellButtonType:.error)
    }
    
    func showLoading() {
        self.contentView.scrollEnabled(false)
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
        loadingCell.loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.contentView.reloadData()
        }
        
    }
    
    func hideLoading() {
        self.contentView.scrollEnabled(true)
        contentSection.removeAllRows()
        
    }
    
    func setContent(blogArray : [Whatson]){
        for blog in blogArray {
            addBlog(blog: blog)
        }
        contentView.reloadData()
    }
}
