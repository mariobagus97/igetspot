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

protocol WaitingTransactionTVCDelegate:class {
    func requestStartOrderButtonDidClicked()
    func refreshTitle()
    func processPaymentDidClicked(invoiceID: String, orderId: String, total: Int)
}

class WaitingTransactionTVC: MKTableViewController {
    
    var presenter = WaitingTransactionPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    weak var delegate: WaitingTransactionTVCDelegate?
    var transactionArray: [WaitingTransaction]?
    var virtualAccountVC: FloatingPanelController?
    

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
        getTransactionWaitingList()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getTransactionWaitingList()
        }
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderIDHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.infoMasterCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.packageOrderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.subTotalOrderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderStatusCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.processPaymentCell.name)
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
        self.title = "\(NSLocalizedString("Waiting", comment: ""))(\(totalTransaction))"
        delegate?.refreshTitle()
    }
    
    func removeAllRows() {
        contentSection.removeAllRows()
    }
    
    func getTransactionWaitingList() {
        presenter.getTransactionWaitingList()
    }
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func reloadData(waitingTransactionArray:[WaitingTransaction]) {
        contentSection.removeAllRows()
        self.transactionArray = waitingTransactionArray
        updateTitle(totalTransaction: waitingTransactionArray.count)
        for transaction in waitingTransactionArray {
            let orderIdCell = createOrderIdCell()
            orderIdCell.delegate = self
            contentSection.appendRow(cell: orderIdCell)
            orderIdCell.setContent(orderId: transaction.orderId ?? "", isExpanded: transaction.isExpand)
            if transaction.isExpand, let masterArray = transaction.masterArray, masterArray.count > 0 {
                let totalPayment = addOrderMaster(masterArray: masterArray, orderId: transaction.orderId)
                if isPaymentEnableForTransaction (transaction: transaction){
                    let processPaymentCell = createProcessPaymentCell()
                    processPaymentCell.orderId = transaction.orderId
                    processPaymentCell.total = totalPayment
                    
                    if let masterArray = transaction.masterArray, masterArray.count > 0 {
                        processPaymentCell.tXid = getTxId(masterArray: masterArray)
                        processPaymentCell.invoiceID = masterArray[0].invoiceID
                    }
                    processPaymentCell.delegate = self
                    contentSection.appendRow(cell: processPaymentCell)
                }
            }
        }
        contentView.reloadData()
    }
    
    private func addOrderMaster(masterArray: [WaitingTransactionMaster], orderId:String?) -> Int {
        var subTotalPrice = 0
        for master in masterArray {
            let infoMasterCell = createInfoMasterCell()
            contentSection.appendRow(cell: infoMasterCell)
            infoMasterCell.setContent(masterName: master.masterName, masterInfo: master.masterOf, masterImageUrl: master.masterImageUrl ?? "", masterId: master.masterId)
            if let packageArray = master.packageArray, packageArray.count > 0 {
                subTotalPrice = addOrderPackage(orderPackageArray: packageArray, orderId: orderId)
                let subTotalOrderCell = createSubtotalOrderCell()
                contentSection.appendRow(cell: subTotalOrderCell)
                subTotalOrderCell.setContent(price: "\(subTotalPrice)")
            }
        }
        return subTotalPrice
    }
    
    private func addOrderPackage(orderPackageArray:[OrderPackage], orderId:String?) -> Int {
        var totalPrice = 0
        for orderPackage in orderPackageArray {
            let packageOrderCell = createPackageOrderCell()
            contentSection.appendRow(cell: packageOrderCell)
            packageOrderCell.isClickable = true
            packageOrderCell.orderId = orderId
            packageOrderCell.setContent(orderPackage: orderPackage)
            packageOrderCell.hideChecklistButton()
            
            if let packagePrice = orderPackage.packagePrice, let packagePriceInt = Int(packagePrice), let orderStatusString = orderPackage.orderStatus, let orderStatusInt = Int(orderStatusString), let orderStatus = OrderStatus(rawValue: orderStatusInt) {
                if (orderStatus == .waitingConfirmation) {
                    totalPrice = totalPrice + packagePriceInt
                    packageOrderCell.showDeleteButton()
                }
                if (orderStatus == .waitingForPayment) {
                    totalPrice = totalPrice + packagePriceInt
                    packageOrderCell.hideDeleteButton()
                }
            }
            
            let orderStatusCell = createOrderStatusCell()
            contentSection.appendRow(cell: orderStatusCell)
            orderStatusCell.statusLabel.text = orderPackage.orderStatusString
        }
        return totalPrice
    }
    
    private func getTxId(masterArray: [WaitingTransactionMaster]) -> String? {
        for master in masterArray {
            if let packageArray = master.packageArray, packageArray.count > 0 {
                for package in packageArray {
                    if let txid = package.txId, txid.isEmptyOrWhitespace() == false {
                        return txid
                    }
                }
            }
        }
        return nil
    }
    
    private func isPaymentEnableForTransaction(transaction:WaitingTransaction) -> Bool {
        return transaction.paymentStatus == "1"

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
        cell.delegate = self
        return cell
    }
    
    private func createInfoMasterCell() -> InfoMasterCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.infoMasterCell.name) as! InfoMasterCell
        cell.delegate = self
        return cell
    }
    
    private func createPackageOrderCell() -> PackageOrderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageOrderCell.name) as! PackageOrderCell
        cell.delegate = self
        return cell
    }
    
    private func createSubtotalOrderCell() -> SubTotalOrderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.subTotalOrderCell.name) as! SubTotalOrderCell
        return cell
    }
    
    private func createProcessPaymentCell() -> ProcessPaymentCell {
        let processPaymentCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.processPaymentCell.name) as! ProcessPaymentCell
        return processPaymentCell
    }
    
    func showVA(txid: String){
        virtualAccountVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        virtualAccountVC?.surfaceView.cornerRadius = 8.0
        virtualAccountVC?.surfaceView.shadowHidden = false
        virtualAccountVC?.isRemovalInteractionEnabled = true
        virtualAccountVC?.panGestureRecognizer.isEnabled = false
        virtualAccountVC?.delegate = self
        
        let contentVC = TransactionVirtualAccountTVC()
        contentVC.txId = txid
        contentVC.delegate = self
        
        // Set a content view controller
        virtualAccountVC?.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        self.present(virtualAccountVC!, animated: true, completion: nil)
    }
    
    private func hideVA() {
        if let virtualAccountVC = self.virtualAccountVC {
            virtualAccountVC.dismiss(animated: true, completion: nil)
        }
    }
    
    private func deleteOrder(packageId:String, orderId:String) {
        showAlertMessage(title: NSLocalizedString("Delete", comment: ""), message: NSLocalizedString("Are you sure want to cancel this package ?", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Delete", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.presenter.deleteTransactionPackage(orderId: orderId, packageId: packageId)            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
}

// MARK: - WaitingTransactionView
extension WaitingTransactionTVC: WaitingTransactionView {
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
        updateTitle(totalTransaction: 0)
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(transactionArray:[WaitingTransaction]) {
        reloadData(waitingTransactionArray: transactionArray)
    }
    
    func showTransactionLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideTransactionLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
    
    func showMessageSuccess(message:String) {
        showSuccessMessageBanner(message)
    }
    
    func handleSuccessDelete() {
        getTransactionWaitingList()
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
extension WaitingTransactionTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getTransactionWaitingList()
        } else {
            delegate?.requestStartOrderButtonDidClicked()
        }
    }
}

// MARK: - PackageOrderCellDelegate
extension WaitingTransactionTVC: PackageOrderCellDelegate {
    func deleteButtonDidClicked(orderPackage: OrderPackage, masterId:String?) {
        
    }
    
    func deleteButtonDidClicked(orderPackage: OrderPackage, orderId:String?) {
        guard let packageId = orderPackage.packageId, let orderIdString = orderId else {
            return
        }
        deleteOrder(packageId: packageId, orderId: orderIdString)
    }
    
    func checkListButtonDidClicked(orderPackage: OrderPackage) {
        
    }
}
// MARK: - OrderIDHeaderCellDelegate
extension WaitingTransactionTVC: OrderIDHeaderCellDelegate {
    func orderIdCellDidClicked(orderId:String, isExpanded:Bool) {
        guard let transactionArray = self.transactionArray else {
            return
        }
        transactionArray.first(where: { $0.orderId == orderId })?.isExpand = !isExpanded
        contentSection.removeAllRows()
        setContent(transactionArray: transactionArray)
    }
}

// MARK: - ProcessPaymentCellDelegate
extension WaitingTransactionTVC: ProcessPaymentCellDelegate {
    func processPaymentButtonDidClicked(invoiceID:String?, orderId:String, txId:String?, total: Int) {
        if let txid = txId {
            // user has get virtual account, show virtual account
            onWaitingPaymentClicked(txid: txid)
        } else {
            // user not get virtual account, process payment
            delegate?.processPaymentDidClicked(invoiceID: invoiceID ?? "", orderId: orderId, total: total)
        }
    }
}

// MARK: - OrderStatusCellDelegate
extension WaitingTransactionTVC : OrderStatusCellDelegate {
    func onWaitingPaymentClicked(txid: String) {
        if(!txid.isEmptyOrWhitespace()){
            showVA(txid: txid)
        }
    }
}

// MARK: - FloatingPanelControllerDelegate
extension WaitingTransactionTVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == virtualAccountVC {
            return FullPanelLayout()
        }
        return nil
    }
}

// MARK: - TransactionVirtualAccountTVCDelegate
extension WaitingTransactionTVC : TransactionVirtualAccountTVCDelegate {
    func closePanel() {
        hideVA()
    }
}

// MARK: - InfoMasterCellDelegate
extension WaitingTransactionTVC : InfoMasterCellDelegate {
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
