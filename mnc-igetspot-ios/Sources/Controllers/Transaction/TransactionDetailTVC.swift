////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh
import FloatingPanel

class TransactionDetailTVC: MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var presenter = TransactionDetailPresenter()
    var transactionStatusFPC: FloatingPanelController?
    var masterLocationFPC: FloatingPanelController?
    var orderId:String?
    var packageId:String?
    var transactionId: String?
    var transactionDetail: TransactionDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter.attachview(self)
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getTransactionDetail()
        }
        getTransactionDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Transaction Detail", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderSectionHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderInformationCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderInformationCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionDetailOrderCompleteCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionDetailHelpContactStatusCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Functions
    func getTransactionDetail() {
        guard let packageId = self.packageId, let orderId = self.orderId else {
            return
        }
        presenter.getTransactionDetail(packageId: packageId, transactionId: orderId)
    }
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createOrderSectionHeaderCell() -> OrderSectionHeaderCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderSectionHeaderCell.name) as! OrderSectionHeaderCell
    }
    
    private func createOrderInformationCell() -> OrderInformationCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderInformationCell.name) as! OrderInformationCell
    }
    
    private func createTransactionDetailOrderCompleteCell() -> TransactionDetailOrderCompleteCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionDetailOrderCompleteCell.name) as! TransactionDetailOrderCompleteCell
    }
    
    private func createTransactionDetailHelpContactStatusCell() -> TransactionDetailHelpContactStatusCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionDetailHelpContactStatusCell.name) as! TransactionDetailHelpContactStatusCell
    }
    
    private func createMySpotOrderInformationCell() -> MySpotOrderInformationCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderInformationCell.name) as! MySpotOrderInformationCell
    }
    
    private func showTransactionStatusFPC(orderId:String, packageId:String) {
        transactionStatusFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        transactionStatusFPC?.surfaceView.cornerRadius = 8.0
        transactionStatusFPC?.surfaceView.shadowHidden = false
        transactionStatusFPC?.isRemovalInteractionEnabled = true
        transactionStatusFPC?.delegate = self
        
        let contentVC = TransactionStatusVC()
        contentVC.orderId = orderId
        contentVC.packageId = packageId
        contentVC.delegate = self
        
        // Set a content view controller
        transactionStatusFPC?.set(contentViewController: contentVC)
        self.present(transactionStatusFPC!, animated: true, completion: nil)
    }
    
    private func hideTransactionStatusFPC(animated:Bool) {
        if let transactionStatusFPC = self.transactionStatusFPC {
            transactionStatusFPC.dismiss(animated: animated, completion: nil)
        }
    }
    
    private func showMasterLocationFPC() {
        masterLocationFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        masterLocationFPC?.surfaceView.cornerRadius = 8.0
        masterLocationFPC?.surfaceView.shadowHidden = false
        masterLocationFPC?.isRemovalInteractionEnabled = true
        masterLocationFPC?.delegate = self
        
        let contentVC = MasterLocationVC()
        contentVC.delegate = self
        
        // Set a content view controller
        masterLocationFPC?.set(contentViewController: contentVC)
        self.present(masterLocationFPC!, animated: true, completion: nil)
    }
    
    private func hideMasterLocationFPC(animated:Bool) {
        if let masterLocationFPC = self.masterLocationFPC {
            masterLocationFPC.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - TransactionDetailView
extension TransactionDetailTVC: TransactionDetailView {
    func showLoadingView() {
        if contentSection.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            contentSection.removeAllRows()
            createLoadingCell()
            contentSection.appendRow(cell: loadingCell)
            loadingCell.updateHeight(100)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.contentView.reloadData()
            }
        }
    }
    
    func hideLoadingView() {
        hideCRRefresh()
        contentView.scrollEnabled(true)
        contentSection.removeAllRows()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType? ) {
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(transactionDetail:TransactionDetail) {
        self.transactionDetail = transactionDetail
        
        // Order Information Section
        let orderInformationCell = createOrderSectionHeaderCell()
        contentSection.appendRow(cell: orderInformationCell)
        orderInformationCell.titleLabel.text = NSLocalizedString("Order Information", comment: "")
        
        // Name
        let nameCell = createOrderInformationCell()
        nameCell.titleLabel.text = NSLocalizedString("Name", comment: "")
        nameCell.valueLabel.text = transactionDetail.userFullName
        contentSection.appendRow(cell: nameCell)
        
        // Email
        let emailCell = createOrderInformationCell()
        emailCell.titleLabel.text = NSLocalizedString("Email", comment: "")
        emailCell.valueLabel.text = transactionDetail.userEmail
        contentSection.appendRow(cell: emailCell)
        
        // Phone Number
        let phoneNumberCell = createOrderInformationCell()
        phoneNumberCell.titleLabel.text = NSLocalizedString("Phone Number", comment: "")
        phoneNumberCell.valueLabel.text = transactionDetail.userPhoneNumber
        contentSection.appendRow(cell: phoneNumberCell)
        
        
        // Transaction Information Section
        let headerTitleCell = createOrderSectionHeaderCell()
        contentSection.appendRow(cell: headerTitleCell)
        headerTitleCell.titleLabel.text = NSLocalizedString("Transaction Information", comment: "")
        
        // Transaction No
        let transactionNumberCell = createOrderInformationCell()
        transactionNumberCell.titleLabel.text = NSLocalizedString("Transaction No.", comment: "")
        transactionNumberCell.valueLabel.text = transactionDetail.transactionNumber
        contentSection.appendRow(cell: transactionNumberCell)
        
        // Master Name
        let masterNameCell = createOrderInformationCell()
        masterNameCell.titleLabel.text = NSLocalizedString("Master Name", comment: "")
        masterNameCell.valueLabel.text = transactionDetail.masterName
        contentSection.appendRow(cell: masterNameCell)
        
        // Package Name
        let packageNameCell = createOrderInformationCell()
        packageNameCell.titleLabel.text = NSLocalizedString("Package Name", comment: "")
        packageNameCell.valueLabel.text = transactionDetail.packageName
        contentSection.appendRow(cell: packageNameCell)
        
        // Price
        let durationCell = createOrderInformationCell()
        durationCell.titleLabel.text = NSLocalizedString("Duration", comment: "")
        durationCell.valueLabel.text = transactionDetail.packageDuration
        contentSection.appendRow(cell: durationCell)
        
        // Price
        let priceCell = createOrderInformationCell()
        priceCell.titleLabel.text = NSLocalizedString("Price", comment: "")
        priceCell.valueLabel.text = transactionDetail.packagePrice?.currency
        contentSection.appendRow(cell: priceCell)
        
        // Notes
        let notesCell = createMySpotOrderInformationCell()
        notesCell.titleLabel.text = NSLocalizedString("Note", comment: "")
        notesCell.valueLabel.text = transactionDetail.orderNote
        notesCell.valueLabel.textColor = UIColor.black
        contentSection.appendRow(cell: notesCell)
        
        // Transaction Information Section
        let orderInformationSectionCell = createOrderSectionHeaderCell()
        contentSection.appendRow(cell: orderInformationSectionCell)
        orderInformationSectionCell.titleLabel.text = NSLocalizedString("Order Information", comment: "")
        
        if let orderStatusString = transactionDetail.orderStatus, let orderStatusInt = Int(orderStatusString), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
            if (orderStatus == .waitingReview) {
                let orderCompleteCell = createTransactionDetailOrderCompleteCell()
                orderCompleteCell.delegate = self
                contentSection.appendRow(cell: orderCompleteCell)
            }
        }
        
        let transactionDetailHelpContactStatusCell = createTransactionDetailHelpContactStatusCell()
        transactionDetailHelpContactStatusCell.delegate = self
        contentSection.appendRow(cell: transactionDetailHelpContactStatusCell)
        
        contentView.reloadData()
    }
}

// MARK: - IGSEmptyCellDelegate
extension TransactionDetailTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getTransactionDetail()
        }
    }
}

// MARK: - TransactionDetailOrderCompleteCellDelegate
extension TransactionDetailTVC: TransactionDetailOrderCompleteCellDelegate {
    func reviewConfirmButtonDidClicked() {
        guard let orderId = self.orderId, let packageId = self.packageId, let transactionDetail = self.transactionDetail else {
            return
        }
        let reviewAndConfirmVC = ReviewAndConfirmVC()
        reviewAndConfirmVC.delegate = self
        reviewAndConfirmVC.orderId = orderId
        reviewAndConfirmVC.packageId = packageId
        reviewAndConfirmVC.masterId = transactionDetail.masterId
        reviewAndConfirmVC.masterName = transactionDetail.masterName
        reviewAndConfirmVC.masterImageUrl = transactionDetail.masterImageUrl
        reviewAndConfirmVC.orderDate = transactionDetail.orderDate
        reviewAndConfirmVC.packageName = transactionDetail.packageName
        self.navigationController?.pushViewController(reviewAndConfirmVC, animated: true)
    }
    
    func reportButtonDidClicked() {
        guard let orderId = self.orderId else {
            return
        }
        let reportThisOrderVC = ReportThisOrderVC()
        reportThisOrderVC.orderId = orderId
        self.navigationController?.pushViewController(reportThisOrderVC, animated: true)
    }
    
    
}

// MARK:- ReviewAndConfirmVCDelegate
extension TransactionDetailTVC: ReviewAndConfirmVCDelegate {
    func handleAfterSuccessReview() {
        getTransactionDetail()
    }
}

// MARK: - TransactionDetailHelpContactStatusCellDelegate
extension TransactionDetailTVC: TransactionDetailHelpContactStatusCellDelegate {
    func viewOrderStatusButtonDidClicked() {
        guard let orderId = self.orderId, let packageId = self.packageId else {
            return
        }
        showTransactionStatusFPC(orderId: orderId, packageId: packageId)
    }
    
    func viewMasterLocationButtonDidClicked() {
        showMasterLocationFPC()
        
    }
    
    func contactUsButtonDidClicked() {
        
    }
}

// MARK:- FloatingPanelControllerDelegate
extension TransactionDetailTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == transactionStatusFPC || vc == masterLocationFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == transactionStatusFPC {
            transactionStatusFPC = nil
        } else if vc == masterLocationFPC {
            masterLocationFPC = nil
        }
    }
}

// MARK:- TransactionStatusVCDelegate
extension TransactionDetailTVC: TransactionStatusVCDelegate {
    func transactionStatusCloseButtonDidClicked() {
        hideTransactionStatusFPC(animated: true)
    }
}

// MARK:- MasterLocationVCDelegate
extension TransactionDetailTVC: MasterLocationVCDelegate {
    func masterLocationCloseButtonDidClicked() {
        hideMasterLocationFPC(animated: true)
    }
    
    func callMasterButtonDidClicked() {
        
    }
    
    func chatMasterButtonDidClicked() {
        
    }
    
    
}
