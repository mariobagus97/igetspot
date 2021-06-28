////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import FloatingPanel

protocol ReviewAndConfirmVCDelegate: class {
    func handleAfterSuccessReview()
}

class ReviewAndConfirmVC: MKViewController {
    
    var presenter = ReviewAndConfirmPresenter()
    var reviewAndConfirmView: ReviewAndConfirmView!
    var thankYouFPC: FloatingPanelController?
    var masterId: String?
    var masterName: String?
    var masterImageUrl: String?
    var masterOf: String?
    var packageName: String?
    var orderDate: String?
    var orderId: String?
    var packageId: String?
    weak var delegate: ReviewAndConfirmVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
        presenter.attachview(self)
        setContent()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Review & Confirm", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func setContent() {
        reviewAndConfirmView.setContent(masterImageUrl: masterImageUrl, masterName: masterName, masterOf: masterOf, packageName: packageName, orderDate: orderDate)
    }
    
    // MARK: - Private Functions
    private func addViews() {
        reviewAndConfirmView = ReviewAndConfirmView()
        reviewAndConfirmView.delegate = self
        view.addSubview(reviewAndConfirmView)
        reviewAndConfirmView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    func showThankYouFPC() {
        thankYouFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        thankYouFPC?.surfaceView.cornerRadius = 8.0
        thankYouFPC?.surfaceView.shadowHidden = false
        thankYouFPC?.isRemovalInteractionEnabled = false
        thankYouFPC?.delegate = self
        
        let contentVC = ReviewAndReportThankYouVC()
        contentVC.thankYouPageType = .afterReviewAndConfirm
        contentVC.delegate = self
        
        // Set a content view controller
        thankYouFPC?.set(contentViewController: contentVC)
        self.present(thankYouFPC!, animated: true, completion: nil)
    }
    
    private func hideThankYouFPC(animated:Bool) {
        if let thankYouFPC = self.thankYouFPC {
            thankYouFPC.dismiss(animated: animated, completion: nil)
        }
    }

}

// MARK: - ReviewAndConfirmDelegate
extension ReviewAndConfirmVC: ReviewAndConfirmDelegate {
    func showReviewLoadingHUD() {
        showLoadingHUD()
    }
    func hideReviewLoadingHUD() {
        hideLoadingHUD()
    }
    func handleReviewSuccess() {
        showThankYouFPC()
    }
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
}

// MARK: - ReviewAndConfirmViewDelegate
extension ReviewAndConfirmVC: ReviewAndConfirmViewDelegate {
    func reviewSubmitButtonDidClicked(serviceQuality:Double, timelinessRating:Double, qualityRating:Double, comment:String) {
        if let masterId = self.masterId, let orderId = self.orderId, let packageId = self.packageId,  comment.isEmptyOrWhitespace() == false, let serviceQualityInt = serviceQuality.toInt(), serviceQualityInt > 0, let timelinessRatingInt = timelinessRating.toInt(), timelinessRatingInt > 0, let qualityRatingInt = qualityRating.toInt(), qualityRatingInt > 0 {
            
            presenter.postRatingOrder(masterId: masterId, orderId: orderId, packageId: packageId, serviceQuality:serviceQualityInt, timelinessRating:timelinessRatingInt, qualityRating:qualityRatingInt, comment: comment)
        } else {
            showErrorMessageBanner(NSLocalizedString("Oops, please give rating for all category and your comment for this order ", comment: ""))
        }
    }
    
}

// MARK: - ReviewAndReportThankYouVCDelegate
extension ReviewAndConfirmVC: ReviewAndReportThankYouVCDelegate {
    func reviewAndReportThankYouCloseButtonDidClicked() {
        hideThankYouFPC(animated: true)
        delegate?.handleAfterSuccessReview()
        navigationController?.popViewController(animated: true)
    }
    
    func backToTransactionButtonDidClicked() {
        hideThankYouFPC(animated: false)
        delegate?.handleAfterSuccessReview()
        navigationController?.popViewController(animated: true)
    }
}

// MARK:- FloatingPanelControllerDelegate
extension ReviewAndConfirmVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == thankYouFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        hideThankYouFPC(animated: true)
        delegate?.handleAfterSuccessReview()
        navigationController?.popViewController(animated: true)
    }

    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == thankYouFPC {
            thankYouFPC = nil
        }
    }
}
