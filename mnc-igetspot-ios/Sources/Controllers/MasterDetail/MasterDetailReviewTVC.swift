//
//  MasterDetailReviewTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterDetailReviewTVC : MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var headerCell = MasterDetailReviewHeaderCell()
    var commentCell = MasterDetailReviewCommentCell()
    var emptyCell: EmptyCell!
    var loadingCell: LoadingCell!
    var ratingDetail:RatingDetail?
    var mPresenter = MasterDetailReviewPresenter()
    var masterId: String?
    var allReviewList = [ReviewList]()
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mPresenter.attachview(self)
        if let masterId = self.masterId {
            getReviewAndRating(forMasterId: masterId)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailReviewHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailReviewCommentCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.masterDetailReviewListCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.removeAllSection()
        let headerSection = MKTableViewSection()
        headerSection.appendRow(cell: headerCell)
        //contentSection.appendRow(cell: commentCell)
        contentView.appendSection(headerSection)
        contentView.appendSection(contentSection)
        contentView.reloadData()
    }
    
    override func createRows() {
        super.createRows()
        createReviewHeaderCell()
        createReviewAddCommentCell()
    }
    
    // MARK: - Private Functions
    private func createReviewHeaderCell() {
        headerCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailReviewHeaderCell.name) as! MasterDetailReviewHeaderCell
        headerCell.delegate = self
    }
    
    private func createReviewAddCommentCell() {
        commentCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailReviewCommentCell.name) as! MasterDetailReviewCommentCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.emptyCell.name) as? EmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func showReviewList(withRating rating:Int = 0){
        contentSection.removeAllRows()
        var filterArrayReview = allReviewList
        if rating > 0 {
            filterArrayReview = allReviewList.filter { $0.rate == Double(rating) }
        }
        if filterArrayReview.count == 0 {
            showReviewListEmptyView(withMessage: NSLocalizedString("No review for selected rating", comment: ""))
        } else {
            for review in filterArrayReview {
                addReviewList(review: review)
            }
        }
        self.contentView.reloadData()
    }
    
    private func addReviewList(review : ReviewList) {
        let reviewListCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailReviewListCell.name) as! MasterDetailReviewListCell
        reviewListCell.setContent(reviewList: review)
        contentSection.appendRow(cell: reviewListCell)
    }
    
    // MARK: - Public Functions
    func getReviewAndRating(forMasterId masterId: String) {
        mPresenter.getReviewDetail(forMasterId: masterId)
    }
    
}

// MARK: - MasterDetailReviewView
extension MasterDetailReviewTVC: MasterDetailReviewView {
    func showRatingDetail(ratingDetail: RatingDetail) {
        headerCell.setContent(ratingDetail: ratingDetail)
        if let reviewList = ratingDetail.reviewList, reviewList.count > 0 {
            allReviewList = reviewList
            headerCell.filterRatingView.setCurrentSelectedRating(currentRating: "all")
        }
        contentView.reloadData()
    }
    
    func showReviewListLoadingView() {
        headerCell.alpha = 0.0
        contentSection.removeAllRows()
        createLoadingCell()
        contentSection.appendRow(cell: loadingCell)
        loadingCell.updateHeight(20)
        loadingCell.loadingIndicatorView.startAnimating()
        contentView.reloadData()
    }
    
    func hideReviewListLoadingView() {
        contentSection.removeAllRows()
        contentView.reloadData()
        headerCell.alpha = 1.0
    }
    
    func showReviewListEmptyView(withMessage message:String) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
}

// MARK: - MasterDetailReviewHeaderCellDelegate
extension MasterDetailReviewTVC: MasterDetailReviewHeaderCellDelegate {
    
    func showRating(withSelectedRating rating:Int) {
        showReviewList(withRating: rating)
    }
}
