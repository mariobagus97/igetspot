////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh

protocol HistoryOrderTVCDelegate:class {
    func historyStartOrderButtonDidClicked()
    func historyOrderDidClicked(masterName:String, masterId:String, orderId:String,packageId:String)
    func refreshTitle()
}

class HistoryOrderTVC: MKTableViewController {
    
    var presenter = HistoryOrderPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    weak var delegate: HistoryOrderTVCDelegate?
    var orderHistoryArray: [OrderHistoryV2]?
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
        presenter.attachview(self)
        getHistoryOrderList()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getHistoryOrderList()
        }
    }
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.orderHistoryListCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Public Funtions
    func removeAllRows() {
        contentSection.removeAllRows()
    }
    
    func getHistoryOrderList() {
        presenter.getHistoryOrderList()
    }
    
    func updateTitle(_ totalHistoryOrder: Int) {
        self.title = "\(NSLocalizedString("History", comment: ""))(\(totalHistoryOrder))"
        delegate?.refreshTitle()
    }
    
    // MARK: - Private Funtions
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func addOrderHistory(orderHistory : OrderHistoryV2) {
        let cell = createOrderHistoryCell()
        cell.delegate = self
        contentSection.appendRow(cell: cell)
        let packageId = orderHistory.masterServicesList?[0].packageID
        cell.setContent(userId: orderHistory.masterID, name: orderHistory.masterName, description: orderHistory.masterOf, profileImageUrl: orderHistory.masterImageURL ?? "", masterID: orderHistory.masterID, orderID: orderHistory.orderID, packageId: String(packageId ?? 0))
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createOrderHistoryCell() -> OrderHistoryListCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.orderHistoryListCell.name) as! OrderHistoryListCell
        return cell
    }
    
    func searchHistory(keyword: String){
        self.searchKeyword = keyword
        if let array = self.orderHistoryArray {
            contentSection.removeAllRows()
            let resultArray = array.filter {
                $0.masterName?.contains(keyword) ?? false
            }
            
            if (resultArray.count == 0){
                self.showEmptyView(withMessage: NSLocalizedString("You don't have any request with keyword \"\(self.searchKeyword)\"", comment: ""), description: nil, buttonTitle: nil, emptyCellButtonType: .start)
                return
            }
            
            for history in resultArray {
                addOrderHistory(orderHistory: history)
            }
            contentView.reloadData()
        }
    }
    
    func resetHistory(){
        if let array = self.orderHistoryArray, array.count > 0 {
            setContent(orderHistoryArray: self.orderHistoryArray!)
        } else {
            showEmptyView(withMessage: NSLocalizedString("You don't have any list of order history", comment: ""),
                               description: NSLocalizedString("Need a creative service?", comment: ""),
                               buttonTitle: NSLocalizedString("Start Order", comment: ""), emptyCellButtonType:.start)
        }
    }
    
}

// MARK: - IGSEmptyCellDelegate
extension HistoryOrderTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getHistoryOrderList()
        } else {
            delegate?.historyStartOrderButtonDidClicked()
        }
    }
}

// MARK: - OrderHistoryListCellDelegate
extension HistoryOrderTVC: OrderHistoryListCellDelegate {
    
    func orderSuccessListDidClicked(orderSuccess: MySpotOrderSuccess) {
        
    }
    
    func orderHistoryListDidClicked(name:String, userId:String,masterID: String, orderID: String, packageID: String) {
        delegate?.historyOrderDidClicked(masterName: name, masterId: userId, orderId: orderID,packageId: packageID)
    }
}

// MARK: - RequestOrderView
extension HistoryOrderTVC: HistoryOrderView {
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
        contentView.scrollEnabled(true)
        contentSection.removeAllRows()
        hideCRRefresh()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        contentSection.removeAllRows()
        updateTitle(0)
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(orderHistoryArray : [OrderHistoryV2]) {
        contentSection.removeAllRows()
        self.orderHistoryArray = orderHistoryArray
        updateTitle(orderHistoryArray.count)
        for history in orderHistoryArray {
            addOrderHistory(orderHistory: history)
        }
        contentView.reloadData()
    }
}
