//
//  MySpotOrderRequestDetailTVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 25/03/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import CRRefresh
import SwiftMessages
import FloatingPanel

protocol MySpotOrderRequestDetailTVCDelegate:class {
    func refreshOrderWaiting()
    func backToMyOrderSuccess()
}

class MySpotOrderRequestDetailTVC: MKTableViewController {
    
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var mySpotOrderDetailConfirmDeclineCell: MySpotOrderDetailConfirmDeclineCell!
    var finishOrderCell: MySpotOrderDetailFinishOrderCell!
    var presenter = MySpotOrderRequestDetailPresenter()
    var orderId:String?
    var packageId:String?
    var invoiceId:String?
    var orderRequestDetail: MySpotOrderRequestDetail?
    var transactionStatusFPC: FloatingPanelController?
    weak var delegate: MySpotOrderRequestDetailTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter.attachview(self)
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getOrderDetail()
        }
        getOrderDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (finishOrderCell != nil) {
            finishOrderCell.swipeToFinishOrderButton.reset()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Order Request Detail", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderSectionHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderInformationCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderInformationCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderDetailConfirmDeclineCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderDetailFinishOrderCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    func getOrderDetail() {
        guard let packageId = self.packageId, let orderId = self.orderId else {
            return
        }
        presenter.getOrderDetail(packageId: packageId, orderId: orderId)
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
    
    private func createMySpotOrderInformationCell() -> MySpotOrderInformationCell {
        return contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderInformationCell.name) as! MySpotOrderInformationCell
    }
    
    private func createMySpotOrderDetailConfirmDeclineCell() {
        mySpotOrderDetailConfirmDeclineCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderDetailConfirmDeclineCell.name) as? MySpotOrderDetailConfirmDeclineCell
        mySpotOrderDetailConfirmDeclineCell.delegate = self
    }
    
    private func createMySpotFinishOrderCell() {
        finishOrderCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderDetailFinishOrderCell.name) as? MySpotOrderDetailFinishOrderCell
        finishOrderCell.delegate = self
    }
    
    private func showTransactionStatusFPC(orderId:String, packageId:String) {
        transactionStatusFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        transactionStatusFPC?.surfaceView.cornerRadius = 8.0
        transactionStatusFPC?.surfaceView.shadowHidden = false
        transactionStatusFPC?.isRemovalInteractionEnabled = true
        transactionStatusFPC?.delegate = self
        
        let contentVC = TransactionStatusVC()
        contentVC.delegate = self
        contentVC.orderId = orderId
        contentVC.packageId = packageId
        
        // Set a content view controller
        transactionStatusFPC?.set(contentViewController: contentVC)
        self.present(transactionStatusFPC!, animated: true, completion: nil)
    }
    
    private func hideTransactionStatusFPC(animated:Bool) {
        if let transactionStatusFPC = self.transactionStatusFPC {
            transactionStatusFPC.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - IGSEmptyCellDelegate
extension MySpotOrderRequestDetailTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getOrderDetail()
        }
    }
}

// MARK: - MySpotOrderDetailActionCellDelegate
extension MySpotOrderRequestDetailTVC: MySpotOrderDetailConfirmDeclineCellDelegate {
    func declineButtonDidClicked() {
        guard let packageId = self.packageId, let orderId = self.orderId else {
            return
        }
        showAlertMessage(title: NSLocalizedString("Decline Order", comment: ""), message: NSLocalizedString("Are you sure to decline this order?", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Decline", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.presenter.confirmOrder(isConfirm: false, packageId: packageId, orderId: orderId)
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
    func confirmButtonDidClicked() {
        guard let packageId = self.packageId, let orderId = self.orderId else {
            return
        }
        showAlertMessage(title: NSLocalizedString("Confirm Order", comment: ""), message: NSLocalizedString("Are you sure to confirm this order?", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Confirm", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.presenter.confirmOrder(isConfirm: true, packageId: packageId, orderId: orderId)
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
}

// MARK: - MySpotOrderRequestDetailView
extension MySpotOrderRequestDetailTVC: MySpotOrderRequestDetailView {
    func showOrderLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideOrderLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
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
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(orderRequestDetail:MySpotOrderRequestDetail) {
        self.orderRequestDetail = orderRequestDetail
        
        let headerTitleCell = createOrderSectionHeaderCell()
        contentSection.appendRow(cell: headerTitleCell)
        headerTitleCell.titleLabel.text = NSLocalizedString("Transaction Information", comment: "")
        
        // Date
        let dateCell = createOrderInformationCell()
        dateCell.titleLabel.text = NSLocalizedString("Date", comment: "")
        dateCell.valueLabel.text = orderRequestDetail.orderDateString
        contentSection.appendRow(cell: dateCell)
        
        // Time
        let timeCell = createOrderInformationCell()
        timeCell.titleLabel.text = NSLocalizedString("Time", comment: "")
        timeCell.valueLabel.text = orderRequestDetail.orderTimeString
        contentSection.appendRow(cell: timeCell)
        
        // Name
        let nameCell = createOrderInformationCell()
        nameCell.titleLabel.text = NSLocalizedString("Customer Name", comment: "")
        nameCell.valueLabel.text = orderRequestDetail.userFirstLastName
        contentSection.appendRow(cell: nameCell)
        
        // Email
        let emailCell = createOrderInformationCell()
        emailCell.titleLabel.text = NSLocalizedString("Email", comment: "")
        emailCell.valueLabel.text = orderRequestDetail.userEmail
        contentSection.appendRow(cell: emailCell)
        
        // Address
        let addressCell = createMySpotOrderInformationCell()
        addressCell.titleLabel.text = NSLocalizedString("Address", comment: "")
        addressCell.valueLabel.text = orderRequestDetail.orderAddress
        contentSection.appendRow(cell: addressCell)
        
        // Notes
        let notesCell = createMySpotOrderInformationCell()
        notesCell.titleLabel.text = NSLocalizedString("Note", comment: "")
        notesCell.valueLabel.text = orderRequestDetail.orderNotes
        contentSection.appendRow(cell: notesCell)
        
        // Price
        let priceCell = createOrderInformationCell()
        priceCell.titleLabel.text = NSLocalizedString("Total", comment: "")
        priceCell.valueLabel.font = R.font.barlowMedium(size: 18)
        priceCell.valueLabel.text = orderRequestDetail.packagePrice?.currency
        priceCell.separatorView.alpha = 0.0
        contentSection.appendRow(cell: priceCell)
        
        if let orderStatusString = orderRequestDetail.orderStatus, let orderStatusInt = Int(orderStatusString), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
            if orderStatus == .waitingConfirmation {
                createMySpotOrderDetailConfirmDeclineCell()
                contentSection.appendRow(cell: mySpotOrderDetailConfirmDeclineCell)
            } else if orderStatus == .active {
                createMySpotFinishOrderCell()
                finishOrderCell.delegate = self
                contentSection.appendRow(cell: finishOrderCell)
            }
        }
        
        contentView.reloadData()
    }
    
    
    
    func handleConfirmDeclinedOrder(isConfirm:Bool) {
        let message = isConfirm ? NSLocalizedString("Order has been confirmed", comment: "") : NSLocalizedString("Order has been declined", comment: "")
        showSuccessMessageBanner(message)
        delegate?.refreshOrderWaiting()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MySpotOrderDetailFinishOrderCellDelegate
extension MySpotOrderRequestDetailTVC: MySpotOrderDetailFinishOrderCellDelegate {
    func viewOrderStatusButtonDidClicked() {
        guard let packageId = self.packageId, let orderId = self.orderId else {
            return
        }
        showTransactionStatusFPC(orderId: orderId, packageId: packageId)
    }
    
    func finishOrderButtonDidClicked() {
        let mySpotFinishOrderVC = MySpotFinishYourOrderVC()
        mySpotFinishOrderVC.orderId = orderId
        mySpotFinishOrderVC.packageID = packageId
        mySpotFinishOrderVC.invoiceID = invoiceId
        mySpotFinishOrderVC.delegate = self
        navigationController?.pushViewController(mySpotFinishOrderVC, animated: true)
    }
}


// MARK:- FloatingPanelControllerDelegate
extension MySpotOrderRequestDetailTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == transactionStatusFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == transactionStatusFPC {
            transactionStatusFPC = nil
        }
    }
}

// MARK:- TransactionStatusVCDelegate
extension MySpotOrderRequestDetailTVC: TransactionStatusVCDelegate {
    func transactionStatusCloseButtonDidClicked() {
        hideTransactionStatusFPC(animated: true)
    }
}

// MARK:- MySpotFinishYourOrderVCDelegate
extension MySpotOrderRequestDetailTVC: MySpotFinishYourOrderVCDelegate {
    func backToMyOrderSuccess() {
        getOrderDetail()
        delegate?.backToMyOrderSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: false)
        }
    }
}
