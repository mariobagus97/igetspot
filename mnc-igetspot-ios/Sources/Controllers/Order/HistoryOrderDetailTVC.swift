////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh
import FloatingPanel

class HistoryOrderDetailTVC: MKTableViewController {

    var presenter = HistoryOrderDetailPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var masterName: String?
    var masterId: String?
    var orderId: String?
    var packageId: String?
    var transactionStatusFPC: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter.attachview(self)
        getHistoryOrderDetail()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getHistoryOrderDetail()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.subTotalOrderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.historyOrderIdStatusCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.historyOrderPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderAgainCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.reviewAndConfirmCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(masterName ?? NSLocalizedString("History Order Detail", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    // MARK: - Public Funtions

    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func getHistoryOrderDetail() {
        guard let masterId = self.masterId else {
            return
        }
        
        guard let orderId = self.orderId else {
            return
        }
        
        guard let packageId = self.packageId else {
            return
        }
        
        presenter.getHistoryOrderDetail(masterId: masterId,orderId: orderId,packageID: packageId)
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createTotalPriceCell() -> SubTotalOrderCell{
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.subTotalOrderCell.name) as! SubTotalOrderCell
        return cell
    }
    
    private func createHistoryOrderIdStatusCell() -> HistoryOrderIdStatusCell{
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.historyOrderIdStatusCell.name) as! HistoryOrderIdStatusCell
        return cell
    }

    private func createHistoryOrderPackageCell() -> HistoryOrderPackageCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.historyOrderPackageCell.name) as! HistoryOrderPackageCell
        return cell
    }
    
    private func createOrderAgainCell() -> OrderAgainCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderAgainCell.name) as! OrderAgainCell
        return cell
    }
    
    private func createReviewAndConfirmCell() -> ReviewAndConfirmCell {
        let reviewAndConfirmCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.reviewAndConfirmCell.name) as! ReviewAndConfirmCell
//        var master = ActiveTransactionMaster()
//        master.masterId = masterId
//        master.masterName = masterName
////        master.masterImageUrl =
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
}

// MARK: - IGSEmptyCellDelegate
extension HistoryOrderDetailTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getHistoryOrderDetail()
        }
    }
}

// MARK: - OrderAgainCellDelegate
extension HistoryOrderDetailTVC: OrderAgainCellDelegate {
    func orderAgainButtonDidClicked(orderPackage: OrderHistoryPackage) {
        if let packageId = orderPackage.packageId, TokenManager.shared.isLogin() {
            presenter.requestOrderPackage(packageId: packageId)
        }
    }
}

// MARK:- FloatingPanelControllerDelegate
extension HistoryOrderDetailTVC: FloatingPanelControllerDelegate {
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
extension HistoryOrderDetailTVC: TransactionStatusVCDelegate {
    func transactionStatusCloseButtonDidClicked() {
        hideTransactionStatusFPC(animated: true)
    }
}

// MARK:- HistoryOrderDetailView
extension HistoryOrderDetailTVC: HistoryOrderDetailView {
    func showOrderLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideOrderLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showErrorMessage(message:String) {
        showErrorMessageBanner(message)
    }
    
    func goToOrderDetail(packageId: String, orderDetail:OrderDetail) {
        let orderDetailTVC = OrderDetailTVC()
        orderDetailTVC.packageId = packageId
        orderDetailTVC.orderDetail = orderDetail
        navigationController?.pushViewController(orderDetailTVC, animated: true)
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
    
    func showEmptyView(withMessage message:String, description:String? = "", buttonTitle:String? = nil, emptyCellButtonType:EmtypCellButtonType? = .error) {
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(orderHistoryDetail:OrderHistoryDetail) {
        guard let orderPackageArray = orderHistoryDetail.orderPackageArray, orderPackageArray.count > 0 else {
            return
        }
        
        let masterOfName = orderHistoryDetail.masterName
        for package in orderPackageArray {
            let orderStatusCell = createHistoryOrderIdStatusCell()
            contentSection.appendRow(cell: orderStatusCell)
            orderStatusCell.setContent(orderId: package.orderId ?? "", statusOrder: package.orderStatus ?? "0", statusOrderString: package.orderStatusString ?? "")
            
            let packageCell = createHistoryOrderPackageCell()
            contentSection.appendRow(cell: packageCell)
            packageCell.setContent(orderPackage: package)
            
            let totalPriceCell = createTotalPriceCell()
            contentSection.appendRow(cell: totalPriceCell)
            totalPriceCell.subTotalTitleLabel.text = NSLocalizedString("Total", comment: "")
            totalPriceCell.subTotalPriceLabel.text = package.packagePrice?.currency
            
            if let orderStatusString = package.orderStatus, let orderStatusInt = Int(orderStatusString), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
                if (orderStatus == .completed) {
                    let orderAgainCell = createOrderAgainCell()
                    contentSection.appendRow(cell: orderAgainCell)
                    orderAgainCell.delegate = self
                    orderAgainCell.setContent(orderPackage: package)
                }
                
                if (orderStatus == .waitingReview) {
                    let reviewConfirm = createReviewAndConfirmCell()
                    contentSection.appendRow(cell: reviewConfirm)
              
                    let transactionMaster = ActiveTransactionMaster()
                    transactionMaster.masterId = self.masterId
                    transactionMaster.masterName = self.masterName
                    transactionMaster.masterImageUrl = package.packageImageUrl
                    transactionMaster.masterOf = masterOfName
                    
                    let transactionPackage = ActiveTransactionPackage()
                    transactionPackage.packageId = package.packageId
                    transactionPackage.packageName = package.packageName
                    transactionPackage.orderDate = package.orderDate
                    
                    reviewConfirm.orderId = self.orderId
                    reviewConfirm.activeTransactionMaster = transactionMaster
                    reviewConfirm.activeTransactionPackage = transactionPackage
                    reviewConfirm.delegate = self
                 
                }
            }
        }
        
        contentView.reloadData()
    }
}



extension HistoryOrderDetailTVC: ReviewAndConfirmCellDelegate {
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
        reviewAndConfirmVC.masterOf = master.masterOf
        self.navigationController?.pushViewController(reviewAndConfirmVC, animated: true)
    }
}


extension HistoryOrderDetailTVC:ReviewAndConfirmVCDelegate {
    func handleAfterSuccessReview() {
        getHistoryOrderDetail()
    }
    
}
