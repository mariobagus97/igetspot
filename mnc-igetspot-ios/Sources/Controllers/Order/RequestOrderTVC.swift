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

protocol RequestOrderTVCDelegate:class {
    func requestStartOrderButtonDidClicked()
    func refreshTitle()
}

let kRefreshDataRequestOrderNotificationName = "kRefreshDataRequestOrderNotification"

class RequestOrderTVC: MKTableViewController {
    var presenter = RequestOrderPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    weak var delegate: RequestOrderTVCDelegate?
    var orderRequestArray: [OrderRequest]?
    var deleteOrderFPC: FloatingPanelController?
    var searchKeyword = ""
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverNotification()
        presenter.attachview(self)
        getRequestOrderList()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getRequestOrderList()
        }
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.infoMasterCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.packageOrderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.subTotalOrderCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.totalOrderProcessCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.addAnotherPackageCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    @objc func handleHasNewOrder() {
        getRequestOrderList()
    }
    
    func removeAllRows() {
        contentSection.removeAllRows()
    }
    
    @objc func getRequestOrderList() {
        self.presenter.getRequestOrderList()
    }
    
    func searchOrder(keyword: String){
        self.searchKeyword = keyword
        if let array = self.orderRequestArray {
            let resultArray = array.filter {
                $0.masterName?.lowercased().contains(keyword.lowercased()) ?? false || $0.orderPackageArray?.contains(where: { $0.packageName?.lowercased().contains(keyword.lowercased()) ?? false }) ?? false
            }
            
            contentSection.removeAllRows()
            
            if (resultArray.count == 0){
                self.showEmptyView(withMessage: NSLocalizedString("You don't have any request with keyword \"\(self.searchKeyword)\"", comment: ""))
                return
            }
            
            var totalPrice = 0
            for orderRequest in resultArray {
                let subTotalPrice = addOrderRequest(orderRequest: orderRequest)
                totalPrice = totalPrice + subTotalPrice
            }
            
            let totalOrderProcessCell = createTotalOrderProcessCell()
            totalOrderProcessCell.delegate = self
            contentSection.appendRow(cell: totalOrderProcessCell)
            totalOrderProcessCell.setContent(price: "\(totalPrice)")
            
            let addAnotherPackageCell = createAddAnotherPackageCell()
            addAnotherPackageCell.delegate = self
            contentSection.appendRow(cell: addAnotherPackageCell)
            contentView.reloadData()
        }
        
        contentView.reloadData()
    }
    
    func resetOrder(){
        if let array = self.orderRequestArray, array.count > 0 {
            self.setContent(orderRequestArray: self.orderRequestArray!)
        } else {
            self.showEmptyView(withMessage: NSLocalizedString("You don't have any order request yet", comment: ""),
                               description: NSLocalizedString("Need a creative service?", comment: ""),
                               buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
        }
    }
    
    func updateTitle(_ totalRequestOrder: Int) {
        self.title = "\(NSLocalizedString("Waiting", comment: ""))(\(totalRequestOrder))"
        delegate?.refreshTitle()
    }
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func reloadContent(orderRequestArray : [OrderRequest]) {
        contentSection.removeAllRows()
        var totalPrice = 0
        updateTitle(orderRequestArray.count)
        for orderRequest in orderRequestArray {
            let subTotalPrice = addOrderRequest(orderRequest: orderRequest)
            totalPrice = totalPrice + subTotalPrice
        }
        let totalOrderProcessCell = createTotalOrderProcessCell()
        totalOrderProcessCell.delegate = self
        contentSection.appendRow(cell: totalOrderProcessCell)
        totalOrderProcessCell.setContent(price: "\(totalPrice)")
        
        let addAnotherPackageCell = createAddAnotherPackageCell()
        addAnotherPackageCell.delegate = self
        contentSection.appendRow(cell: addAnotherPackageCell)
        contentView.reloadData()
    }
    
    private func addOrderRequest(orderRequest : OrderRequest) -> Int {
        let infoMasterCell = createInfoMasterCell()
        contentSection.appendRow(cell: infoMasterCell)
        infoMasterCell.setContent(masterName: orderRequest.masterName, masterInfo: orderRequest.masterOf, masterImageUrl: orderRequest.masterImageUrl ?? "", masterId: orderRequest.masterId)
        infoMasterCell.hideChatButton()
        if let orderPackageArray = orderRequest.orderPackageArray, orderPackageArray.count > 0 {
            let subTotalPrice = addOrderPackage(orderPackageArray: orderPackageArray, masterId: orderRequest.masterId)
            let subTotalOrderCell = createSubtotalOrderCell()
            contentSection.appendRow(cell: subTotalOrderCell)
            subTotalOrderCell.setContent(price: "\(subTotalPrice)")
            
            return subTotalPrice
        } else {
            return 0
        }
    }
    
    private func addOrderPackage(orderPackageArray:[OrderPackage], masterId:String?) -> Int {
        var totalPrice = 0
        for orderPackage in orderPackageArray {
            let packageOrderCell = createPackageOrderCell()
            contentSection.appendRow(cell: packageOrderCell)
            packageOrderCell.setContent(orderPackage: orderPackage)
            packageOrderCell.isClickable = false
            packageOrderCell.delegate = self
            packageOrderCell.masterId = masterId
            
            if orderPackage.isSelected, let packagePrice = orderPackage.packagePrice, let packagePriceInt = Int(packagePrice) {
                totalPrice = totalPrice + packagePriceInt
            }
        }
        return totalPrice
    }
    
    private func addObserverNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getRequestOrderList), name: NSNotification.Name(kRefreshDataRequestOrderNotificationName), object: nil)
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createInfoMasterCell() -> InfoMasterCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.infoMasterCell.name) as! InfoMasterCell
        return cell
    }
    
    private func createPackageOrderCell() -> PackageOrderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.packageOrderCell.name) as! PackageOrderCell
        return cell
    }
    
    private func createSubtotalOrderCell() -> SubTotalOrderCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.subTotalOrderCell.name) as! SubTotalOrderCell
        return cell
    }
    
    private func createTotalOrderProcessCell() -> TotalOrderProcessCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.totalOrderProcessCell.name) as! TotalOrderProcessCell
        return cell
    }
    
    private func createAddAnotherPackageCell() -> AddAnotherPackageCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.addAnotherPackageCell.name) as! AddAnotherPackageCell
        return cell
    }
    
    private func showDeleteOrderFPC(packageId:String, masterId:String) {
        deleteOrderFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        deleteOrderFPC?.surfaceView.cornerRadius = 8.0
        deleteOrderFPC?.surfaceView.shadowHidden = false
        deleteOrderFPC?.isRemovalInteractionEnabled = true
        deleteOrderFPC?.delegate = self
        
        let contentVC = DeleteOrderVC()
        contentVC.packageId = packageId
        contentVC.masterId = masterId
        contentVC.delegate = self
        
        // Set a content view controller
        deleteOrderFPC?.set(contentViewController: contentVC)
        self.present(deleteOrderFPC!, animated: true, completion: nil)
    }
    
    private func hideDeleteOrderFPC(animated:Bool) {
        if let deleteOrderFPC = self.deleteOrderFPC {
            deleteOrderFPC.dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK:- RequestOrderView
extension RequestOrderTVC: RequestOrderView {
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
        updateTitle(0)
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(orderRequestArray : [OrderRequest]) {
        self.orderRequestArray = orderRequestArray
        reloadContent(orderRequestArray: orderRequestArray)
    }
    
    func handleOrderSuccess() {
        getRequestOrderList()
        showSuccessMessageBanner(NSLocalizedString("Your order has been submitted successfully.", comment: ""))
        if let mainTabBarController = UIApplication.getMainPageTabBarController() {
            mainTabBarController.selectedIndex =  TabBarIndex.transaction
            let navigationController = mainTabBarController.selectedViewController as? UINavigationController
            if let transactionTVC = navigationController?.viewControllers.first as? TransactionTVC {
                transactionTVC.openWaitingTabAndRefreshData()
            }
        }
    }
    
    func showOrderLoadingHUD() {
        showLoadingHUD()
    }
    func hideOrderLoadingHUD() {
        hideLoadingHUD()
    }
    func showMessageSuccess(message:String) {
        showSuccessMessageBanner(message)
    }
    func showMessageError(message:String) {
        showErrorMessageBanner(message)
    }
}

// MARK:- FloatingPanelControllerDelegate
extension RequestOrderTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == deleteOrderFPC {
            return IntrinsicPanelLayout()
        }
        return nil
    }
}

// MARK:- DeleteOrderVCDelegate
extension RequestOrderTVC: DeleteOrderVCDelegate {
    func deleteOrderCloseButtonDidClicked() {
        hideDeleteOrderFPC(animated: true)
    }
    
    func deleteOrderAndSaveToFavorites(packageId:String, masterId:String) {
        hideDeleteOrderFPC(animated: true)
        showAlertMessage(title: NSLocalizedString("Delete & Save To Favorites", comment: ""), message: NSLocalizedString("Are you sure want to delete this package and add to favorite ?", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Delete & Save To Favorites", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.presenter.deletePackageOrderAndSaveToFavorite(packageId: packageId, masterId: masterId)
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
    func deleteOrder(packageId:String, masterId:String) {
        hideDeleteOrderFPC(animated: true)
        showAlertMessage(title: NSLocalizedString("Delete", comment: ""), message: NSLocalizedString("Are you sure want to delete this package ?", comment: ""), iconImage: nil, okButtonTitle: NSLocalizedString("Delete", comment: ""), okAction: { [weak self] in
            SwiftMessages.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.presenter.deletePackageOrder(packageId: packageId)
            }
            }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                SwiftMessages.hide()
        })
    }
    
    
}

// MARK: - IGSEmptyCellDelegate
extension RequestOrderTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getRequestOrderList()
        } else {
            delegate?.requestStartOrderButtonDidClicked()
        }
    }
}

// MARK: - TotalOrderProcessCellDelegate
extension RequestOrderTVC: TotalOrderProcessCellDelegate {
    func processOrderButtonDidClicked() {
        guard let orderRequestArray = self.orderRequestArray else {
            return
        }
        presenter.requestSubmitOrder(orderRequestArray: orderRequestArray)
    }
}

// MARK: - AddAnotherPackageCellDelegate
extension RequestOrderTVC: AddAnotherPackageCellDelegate {
    func addAnotherPackageCellDidClicked() {
        self.tabBarController?.selectedIndex = TabBarIndex.home
    }
}

// MARK: - PackageOrderCellDelegate
extension RequestOrderTVC: PackageOrderCellDelegate {
    func deleteButtonDidClicked(orderPackage:OrderPackage, orderId:String?) {
        
    }
    func deleteButtonDidClicked(orderPackage: OrderPackage, masterId:String?) {
        guard let packageId = orderPackage.packageId, let masterIdString = masterId else {
            return
        }
        showDeleteOrderFPC(packageId: packageId, masterId: masterIdString)
    }
    
    func checkListButtonDidClicked(orderPackage: OrderPackage) {
        guard let orderRequestArray = self.orderRequestArray else {
            return
        }
        for orderRequest in orderRequestArray {
            if let orderPackageArray = orderRequest.orderPackageArray {
                for package in orderPackageArray {
                    if orderPackage.packageId == package.packageId {
                        package.isSelected = !orderPackage.isSelected
                        break
                    }
                }
            }
        }
        reloadContent(orderRequestArray: orderRequestArray)
    }
}
