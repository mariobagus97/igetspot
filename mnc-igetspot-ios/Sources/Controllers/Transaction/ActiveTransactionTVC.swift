////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh
import SwiftMessages
import FloatingPanel

protocol ActiveTransactionTVCDelegate:class {
    func requestStartOrderButtonDidClicked()
    func refreshTitle()
}

class ActiveTransactionTVC: MKTableViewController {
    
    var presenter = ActiveTransactionPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var transactionStatusFPC: FloatingPanelController?
    var transactionArray:[ActiveTransaction]?
    weak var delegate: ActiveTransactionTVCDelegate?
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachview(self)
        getTransactionActiveList()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getTransactionActiveList()
        }
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderIDHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.infoMasterCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderStatusCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.reviewAndConfirmCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionActivePackageCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    func updateTitle(totalTransaction:Int) {
        self.title = "\(NSLocalizedString("Active", comment: ""))(\(totalTransaction))"
        delegate?.refreshTitle()
    }
    
    func removeAllRows() {
        contentSection.removeAllRows()
    }
    
    func getTransactionActiveList() {
        presenter.getTransactionActiveList()
    }
    
    
    // MARK: - Private Funtions
    private func reloadData(transactionArray:[ActiveTransaction]) {
        removeAllRows()
        self.transactionArray = transactionArray
        updateTitle(totalTransaction: transactionArray.count)
        for transaction in transactionArray {
            let orderIdCell = createOrderIdCell()
            contentSection.appendRow(cell: orderIdCell)
            orderIdCell.setContent(orderId: transaction.orderId ?? "", isExpanded: transaction.isExpand)
            orderIdCell.arrowImageView.alpha = 0.0
            if let masterArray = transaction.masterArray, masterArray.count > 0 {
                let _ = addOrderMaster(masterArray: masterArray, orderId: transaction.orderId ?? "", transactionId:transaction.transactionId ?? "")
            }
        }
        contentView.reloadData()
        
    }
    private func addOrderMaster(masterArray: [ActiveTransactionMaster], orderId:String, transactionId:String) -> Int {
        var subTotalPrice = 0
        for master in masterArray {
            let infoMasterCell = createInfoMasterCell()
            contentSection.appendRow(cell: infoMasterCell)
            infoMasterCell.setContent(masterName: master.masterName, masterInfo: master.masterOf, masterImageUrl: master.masterImageUrl ?? "", masterId: master.masterId)
            if let packageArray = master.packageArray, packageArray.count > 0 {
                subTotalPrice = addOrderPackage(master: master, packageArray: packageArray, orderId: orderId, transactionId:transactionId)
            }
        }
        return subTotalPrice
    }
    
    private func addOrderPackage(master:ActiveTransactionMaster, packageArray:[ActiveTransactionPackage], orderId:String, transactionId:String) -> Int {
        var totalPrice = 0
        for orderPackage in packageArray {
            let packageOrderCell = createPackageCell()
            contentSection.appendRow(cell: packageOrderCell)
            packageOrderCell.delegate = self
            packageOrderCell.setContent(transactionPackage: orderPackage, orderId: orderId, transactionId: transactionId)
            
            let orderStatusCell = createOrderStatusCell()
            contentSection.appendRow(cell: orderStatusCell)
            if let orderStatusString = orderPackage.orderStatusString, orderStatusString.isEmpty == false {
                orderStatusCell.statusLabel.text = orderStatusString
            } else {
                orderStatusCell.statusLabel.text = NSLocalizedString("Status not desribed", comment: "")
            }
            
            if let packagePrice = orderPackage.packagePrice, let packagePriceInt = Int(packagePrice) {
                totalPrice = totalPrice + packagePriceInt
            }
            
            if let orderStatusString = orderPackage.orderStatus, let orderStatusInt = Int(orderStatusString), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
                if (orderStatus == .waitingReview) {
                    let reviewAndConfirmCell = createReviewAndConfirmCell()
                    contentSection.appendRow(cell: reviewAndConfirmCell)
                    reviewAndConfirmCell.orderId = orderId
                    reviewAndConfirmCell.activeTransactionMaster = master
                    reviewAndConfirmCell.activeTransactionPackage = orderPackage
                    reviewAndConfirmCell.delegate = self
                }
            }
        }
        return totalPrice
    }
    
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createOrderIdCell() -> OrderIDHeaderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderIDHeaderCell.name) as! OrderIDHeaderCell
        return cell
    }
    
    private func createOrderStatusCell() -> OrderStatusCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderStatusCell.name) as! OrderStatusCell
        return cell
    }
    
    private func createInfoMasterCell() -> InfoMasterCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.infoMasterCell.name) as! InfoMasterCell
        cell.delegate = self
        return cell
    }
    
    private func createPackageCell() -> TransactionActivePackageCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionActivePackageCell.name) as! TransactionActivePackageCell
        return cell
    }
    
    private func createReviewAndConfirmCell() -> ReviewAndConfirmCell {
        let reviewAndConfirmCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.reviewAndConfirmCell.name) as! ReviewAndConfirmCell
        return reviewAndConfirmCell
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
    
    private func goToTransactionDetail(transactionId:String, packageId:String, orderId:String) {
        let transactionDetailTVC = TransactionDetailTVC()
        transactionDetailTVC.packageId = packageId
        transactionDetailTVC.transactionId = transactionId
        transactionDetailTVC.orderId = orderId
        transactionDetailTVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(transactionDetailTVC, animated: true)
    }

}

// MARK: - ActiveTransactionView
extension ActiveTransactionTVC: ActiveTransactionView {
    
    func showLoadingView() {
        if contentSection.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            removeAllRows()
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
        removeAllRows()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        updateTitle(totalTransaction: 0)
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(transactionArray:[ActiveTransaction]) {
        reloadData(transactionArray: transactionArray)
    }
    
    func showTransactionLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideTransactionLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func goToChatRoom(channelUrl:String, opponentId:String, profileImageUrl:String, nickName:String, phoneNumber:String) {
        guard self.transactionArray != nil else {
            return
        }
        
        let chatVC = ChatVC(chatterName:nickName , chatterUserId: opponentId, sendbirdChannelUrl: channelUrl, chatterImageUrl: profileImageUrl, phoneNumber:phoneNumber)
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - IGSEmptyCellDelegate
extension ActiveTransactionTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getTransactionActiveList()
        } else {
            delegate?.requestStartOrderButtonDidClicked()
        }
    }
}

// MARK: - TransactionActivePackageCellDelegate
extension ActiveTransactionTVC: TransactionActivePackageCellDelegate {
    func transactionActiveEyeButtonDidClicked(transactionPackage: ActiveTransactionPackage, orderId: String) {
        guard let packageId = transactionPackage.packageId else {
            return
        }
        showTransactionStatusFPC(orderId: orderId, packageId: packageId)
    }
    
    func transactionActivePackageCellDidSelect(transactionPackage: ActiveTransactionPackage, transactionId: String, orderId: String) {
        if let packageId = transactionPackage.packageId {
            goToTransactionDetail(transactionId: transactionId, packageId:packageId, orderId: orderId)
        }
        
    }
}

// MARK: - ReviewAndConfirmCellDelegate
extension ActiveTransactionTVC: ReviewAndConfirmCellDelegate {
    func reviewAndConfirmButtonDidClicked(orderId:String, master:ActiveTransactionMaster, package:ActiveTransactionPackage) {
        let reviewAndConfirmVC = ReviewAndConfirmVC()
        reviewAndConfirmVC.orderId = orderId
        reviewAndConfirmVC.delegate = self
        reviewAndConfirmVC.packageId = package.packageId
        reviewAndConfirmVC.masterId = master.masterId
        reviewAndConfirmVC.masterName = master.masterName
        reviewAndConfirmVC.masterImageUrl = master.masterImageUrl
        reviewAndConfirmVC.orderDate = package.orderDate
        reviewAndConfirmVC.packageName = package.packageName
        self.navigationController?.pushViewController(reviewAndConfirmVC, animated: true)
    }
}

// MARK:- ReviewAndConfirmVCDelegate
extension ActiveTransactionTVC: ReviewAndConfirmVCDelegate {
    func handleAfterSuccessReview() {
        getTransactionActiveList()
    }
}

// MARK:- FloatingPanelControllerDelegate
extension ActiveTransactionTVC: FloatingPanelControllerDelegate {
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
extension ActiveTransactionTVC: TransactionStatusVCDelegate {
    func transactionStatusCloseButtonDidClicked() {
        hideTransactionStatusFPC(animated: true)
    }
}

// MARK: - InfoMasterCellDelegate
extension ActiveTransactionTVC : InfoMasterCellDelegate {
    func chatButtonDidClicked(masterId: String) {
        if let currentUserId = TokenManager.shared.getUserId() {
            if (currentUserId == masterId) {
                let chatListVC = ChatListTVC()
                navigationController?.pushViewController(chatListVC, animated: true)
            } else {
                presenter.getChannelRoom(currentUserId: currentUserId, opponentId: masterId)
            }
        } else {
            self.goToLoginScreen(afterLoginScreenType: .masterDetail)
        }
    }
}
