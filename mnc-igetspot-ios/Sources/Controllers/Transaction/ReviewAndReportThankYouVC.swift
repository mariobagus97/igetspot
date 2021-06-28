////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

enum ReviewAndReportThankYouType {
    case afterReviewAndConfirm
    case afterReportOrder
}

protocol ReviewAndReportThankYouVCDelegate:class {
    func reviewAndReportThankYouCloseButtonDidClicked()
    func backToTransactionButtonDidClicked()
}

class ReviewAndReportThankYouVC: MKViewController {
    
    var headerView: FloatingPanelHeaderView!
    var reviewAndReportThankYouView: ReviewAndReportThankYouView!
    weak var delegate: ReviewAndReportThankYouVCDelegate?
    var thankYouPageType: ReviewAndReportThankYouType = .afterReviewAndConfirm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setContent()
    }

    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.setIconTitle()
        headerView.closeButton.alpha = 0.0
        view.addSubview(headerView)
        
        reviewAndReportThankYouView = ReviewAndReportThankYouView()
        reviewAndReportThankYouView.delegate = self
        view.addSubview(reviewAndReportThankYouView)
        
        headerView.snp.makeConstraints{ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        reviewAndReportThankYouView.snp.makeConstraints{ (make) in
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((headerView?.snp.bottom)!).offset(0)
        }
    }
    
    private func setContent() {
        if thankYouPageType == .afterReviewAndConfirm {
            headerView.titleLabel.text = NSLocalizedString("Review Confirmation", comment: "")
            reviewAndReportThankYouView.descriptionLabel.text = NSLocalizedString("you just finished a project with our Master!", comment: "")
        } else {
            headerView.titleLabel.text = NSLocalizedString("Report Confirmation", comment: "")
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("Our customer service will contact you in 2x24 hours or less (within working days) from 09.00 - 17.00 WIB. If you have any question, you can contact iGetSpot Customer Care at cs@igetspot.com", comment: ""))
            attributedString.setColorForText(textForAttribute: "2x24 hours or less (within working days)", withColor: UIColor.black, withFont: R.font.barlowMedium(size: 12))
            attributedString.setColorForText(textForAttribute: "09.00 - 17.00 WIB.", withColor: UIColor.black, withFont: R.font.barlowMedium(size: 12))
            attributedString.setColorForText(textForAttribute: "cs@igetspot.com", withColor: UIColor.black, withFont: R.font.barlowMedium(size: 12))
            reviewAndReportThankYouView.descriptionLabel.attributedText = attributedString
        }
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension ReviewAndReportThankYouVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.reviewAndReportThankYouCloseButtonDidClicked()
    }
}


// MARK: - ReviewAndReportThankYouViewDelegate
extension ReviewAndReportThankYouVC: ReviewAndReportThankYouViewDelegate {
    func backToTransactionButtonDidClicked() {
        delegate?.backToTransactionButtonDidClicked()
    }
}
