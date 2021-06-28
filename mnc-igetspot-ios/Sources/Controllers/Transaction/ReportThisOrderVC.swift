////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftMessages
import FloatingPanel

class ReportThisOrderVC: MKViewController {
    
    var presenter = ReportThisOrderPresenter()
    var reportThisOrderView: ReportThisOrderView!
    var thankYouFPC: FloatingPanelController?
    var orderId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addViews()
        presenter.attachview(self)
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
        setupNavigationBarTitle(NSLocalizedString("Report This Order", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    // MARK: - Private Functions
    private func addViews() {
        reportThisOrderView = ReportThisOrderView()
        reportThisOrderView.delegate = self
        view.addSubview(reportThisOrderView)
        reportThisOrderView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    private func showReasonListPopupView(selectedReason:String) {
        let view: ReasonReportView = try! SwiftMessages.viewFromNib()
        view.configureNoDropShadow()
        view.delegate = self
        view.selectedReason = selectedReason
        view.setContent(listArray: ["Master not come","Master not expert","Master late" ])
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    
    private func showThankYouFPC() {
        thankYouFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        thankYouFPC?.surfaceView.cornerRadius = 8.0
        thankYouFPC?.surfaceView.shadowHidden = false
        thankYouFPC?.isRemovalInteractionEnabled = false
        thankYouFPC?.delegate = self
        
        let contentVC = ReviewAndReportThankYouVC()
        contentVC.thankYouPageType = .afterReportOrder
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

extension ReportThisOrderVC: ReportThisOrderDelegate {
    func showReportLoadingHUD() {
        showLoadingHUD()
    }
    func hideReportLoadingHUD() {
        hideLoadingHUD()
    }
    func handleReportSuccess() {
        showThankYouFPC()
    }
    
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
}

// MARK: - ReportThisOrderViewDelegate
extension ReportThisOrderVC: ReportThisOrderViewDelegate {
    func submitReportOrderButtonDidClicked(reasonString: String, explainString: String) {
        guard let orderId = self.orderId, reasonString.isEmptyOrWhitespace() == false, explainString.isEmptyOrWhitespace() == false else {
            return
        }
        presenter.postReportOrder(orderId: orderId, reason: reasonString, reasonDescription: explainString)
    }
    
    func showReasonReport() {
        let selectedReason = reportThisOrderView.reasonLabel.text ?? ""
        showReasonListPopupView(selectedReason: selectedReason)
    }
}

// MARK: - ReasonReportViewDelegate
extension ReportThisOrderVC: ReasonReportViewDelegate {
    func reasonReportCloseButtonDidClicked() {
        SwiftMessages.hide()
    }
    
    func reasonDidSelect(reason: String) {
        SwiftMessages.hide()
        reportThisOrderView.setReason(reason)
    }
}

// MARK: - ReviewAndReportThankYouVCDelegate
extension ReportThisOrderVC: ReviewAndReportThankYouVCDelegate {
    func reviewAndReportThankYouCloseButtonDidClicked() {
        hideThankYouFPC(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func backToTransactionButtonDidClicked() {
        hideThankYouFPC(animated: false)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK:- FloatingPanelControllerDelegate
extension ReportThisOrderVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == thankYouFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == thankYouFPC {
            thankYouFPC = nil
        }
    }
}
