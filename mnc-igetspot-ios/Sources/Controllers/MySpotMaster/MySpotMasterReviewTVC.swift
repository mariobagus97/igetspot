////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotMasterReviewTVC: MKTableViewController {

    var contentSection = MKTableViewSection()
    var headerCell = MasterDetailReviewHeaderCell()
    var commentCell = MasterDetailReviewCommentCell()
    var emptyCell: EmptyCell!
    var loadingCell: LoadingCell!
    var ratingDetail:RatingDetail?
    var mPresenter = MySpotMasterReviewPresenter()
    var allReviewList = [ReviewList]()
    
    // MARK:- Init
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mPresenter.attachview(self)
        getReviewAndRating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.reloadData()
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
    func getReviewAndRating() {
        mPresenter.getMySpotReviewDetail()
    }
}

// MARK: - MySpotMasterReviewView
extension MySpotMasterReviewTVC: MySpotMasterReviewView {
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
        headerCell.alpha = 1.0
        contentSection.removeAllRows()
        contentView.reloadData()
    }
    
    func showReviewListEmptyView(withMessage message:String) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.setupCell(withDescription: message)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func showRatingDetail(ratingDetail: RatingDetail) {
        headerCell.setContent(ratingDetail: ratingDetail)
        if let reviewList = ratingDetail.reviewList, reviewList.count > 0 {
            allReviewList = reviewList
            headerCell.filterRatingView.setCurrentSelectedRating(currentRating: "all")
        }
        contentView.reloadData()
    }
}

// MARK: - MasterDetailReviewHeaderCellDelegate
extension MySpotMasterReviewTVC: MasterDetailReviewHeaderCellDelegate {
    func showRating(withSelectedRating rating:Int) {
        showReviewList(withRating: rating)
    }
}
