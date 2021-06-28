////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh
import FloatingPanel

protocol MySpotOrderActiveTVCDelegate:class {
    func refreshOrderActiveTitle()
    func orderActiveDidClicked(orderId: String, packageId:String,invoiceID:String)
}

class MySpotOrderActiveTVC: MKTableViewController {
    var presenter = MySpotOrderActivePresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var transactionStatusFPC: FloatingPanelController?
    var orderActiveArray: [MySpotOrderActive]?
    weak var delegate: MySpotOrderActiveTVCDelegate?

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
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getOrderActiveList()
        }
        getOrderActiveList()
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
        contentView.registeredCellIdentifiers.append(R.nib.orderIDHeaderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderCustomerCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotOrderPackageCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderStatusCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    func getOrderActiveList() {
        self.presenter.getOrderActiveList()
    }
    
    // MARK: - Private Funtions
    private func updateTitle(totalOrder:Int) {
        self.title = "\(NSLocalizedString("Active", comment: ""))(\(totalOrder))"
        delegate?.refreshOrderActiveTitle()
    }
    
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func addOrderPackage(orderPackageArray:[MySpotOrderPackage], orderId:String, invoiceID:String) -> Int {
        var totalPrice = 0
        for orderPackage in orderPackageArray {
            let packageOrderCell = createMySpotOrderPackageCell()
            contentSection.appendRow(cell: packageOrderCell)
            packageOrderCell.setContent(orderPackage: orderPackage,invoiceID: invoiceID)
            packageOrderCell.orderId = orderId
            packageOrderCell.invoiceId = invoiceID
            if let packagePrice = orderPackage.packagePrice, let packagePriceInt = Int(packagePrice) {
                totalPrice = totalPrice + packagePriceInt
            }
            
            let orderStatusCell = createOrderStatusCell()
            contentSection.appendRow(cell: orderStatusCell)
            orderStatusCell.statusLabel.text = orderPackage.orderStatusString
        }
        return totalPrice
    }
    
    private func createOrderStatusCell() -> OrderStatusCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderStatusCell.name) as! OrderStatusCell
        return cell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createOrderCustomerCell() -> MySpotOrderCustomerCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderCustomerCell.name) as! MySpotOrderCustomerCell
        return cell
    }
    
    private func createMySpotOrderPackageCell() -> MySpotOrderPackageCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotOrderPackageCell.name) as! MySpotOrderPackageCell
        cell.delegate = self
        return cell
    }
    
    private func createOrderIdCell() -> OrderIDHeaderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderIDHeaderCell.name) as! OrderIDHeaderCell
        return cell
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

// MARK: - MySpotOrderActiveView
extension MySpotOrderActiveTVC: MySpotOrderActiveView {
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
        updateTitle(totalOrder: 0)
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(orderActiveArray : [MySpotOrderActive]) {
        contentSection.removeAllRows()
        self.orderActiveArray = orderActiveArray
        updateTitle(totalOrder: orderActiveArray.count)
        for order in orderActiveArray {
            let orderIdCell = createOrderIdCell()
            contentSection.appendRow(cell: orderIdCell)
            orderIdCell.arrowImageView.alpha = 0
            orderIdCell.setContent(orderId: order.orderId ?? "", isExpanded: true)
            
            let customerCell = createOrderCustomerCell()
            contentSection.appendRow(cell: customerCell)
            customerCell.setContent(imageUrl: order.userImageUrl ?? "", customerName: order.userFirstNameLastName ?? "")
            
            if let packageArray = order.orderedPackageList, packageArray.count > 0, let orderId = order.orderId {
                let _ = addOrderPackage(orderPackageArray: packageArray, orderId: orderId, invoiceID: order.invoiceId ?? "")
            }
        }
        
        contentView.reloadData()
    }
}

// MARK: - IGSEmptyCellDelegate
extension MySpotOrderActiveTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getOrderActiveList()
        }
    }
}

// MARK:- FloatingPanelControllerDelegate
extension MySpotOrderActiveTVC: FloatingPanelControllerDelegate {
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
extension MySpotOrderActiveTVC: TransactionStatusVCDelegate {
    func transactionStatusCloseButtonDidClicked() {
        hideTransactionStatusFPC(animated: true)
    }
}

// MARK: - MySpotOrderPackageCellDelegate
extension MySpotOrderActiveTVC: MySpotOrderPackageCellDelegate {
    func orderPackageCellDidClicked(orderId: String, packageId: String, invoiceID: String) {
        delegate?.orderActiveDidClicked(orderId: orderId, packageId: packageId,invoiceID: invoiceID)
    }
    
    func eyeButtonDidClicked(orderId:String, packageId:String) {
        showTransactionStatusFPC(orderId: orderId, packageId: packageId)
    }
}
