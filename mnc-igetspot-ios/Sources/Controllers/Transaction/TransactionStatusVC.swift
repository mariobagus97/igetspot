////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh

protocol TransactionStatusVCDelegate:class {
    func transactionStatusCloseButtonDidClicked()
}

class TransactionStatusVC: MKViewController, MKTableViewDelegate {
    
    var headerView: FloatingPanelHeaderView!
    var contentView: MKTableView!
    var presenter = TransactionStatusPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    weak var delegate: TransactionStatusVCDelegate?
    var orderId:String?
    var packageId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        presenter.attachview(self)
        getTransactionStatusList()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getTransactionStatusList()
        }
    }
    
    // MARK: - MKTableViewDelegate
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionStatusCell.name)
    }
    
    func createSections() {
        contentView.appendSection(contentSection)
    }
    
    func createRows() {
        
    }
    
    // MARK: - Public Funtions

    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Transaction Status", comment: "")
        headerView.setIconTitle()
        view.addSubview(headerView)
        
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        view.addSubview(contentView)
        
        headerView.snp.makeConstraints{ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        contentView.snp.makeConstraints{ (make) in
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((headerView?.snp.bottom)!).offset(0)
        }
        
    }
    
    private func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func getTransactionStatusList() {
        guard let orderId = self.orderId, let packageId = self.packageId else {
            return
        }
        presenter.getTransactionStatusList(orderId: orderId, packageId: packageId)
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createTransactionStatusCell() -> TransactionStatusCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionStatusCell.name) as! TransactionStatusCell
        return cell
    }
}

// MARK: - TransactionStatusView
extension TransactionStatusVC: TransactionStatusView {
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
    
    func setContent(transactionStatusArray:[TransactionStatus]) {
        for index in 0..<transactionStatusArray.count {
            let transactionStatus = transactionStatusArray[index]
            let transactionStatusCell = createTransactionStatusCell()
            let nextIndex = index + 1
            var nextTransactionStatus = false
            if nextIndex < transactionStatusArray.count {
                let transactionStatus = transactionStatusArray[nextIndex]
                nextTransactionStatus = transactionStatus.statusDone ?? false
            }
            contentSection.appendRow(cell: transactionStatusCell)
            transactionStatusCell.setContent(transactionStatus: transactionStatus, nextTransactionStatus: nextTransactionStatus)
            if index == 0 {
                transactionStatusCell.topLineView.alpha = 0.0
            } else if index == transactionStatusArray.count - 1 {
                transactionStatusCell.bottomLineView.alpha = 0.0
            }
        }
        contentView.reloadData()
    }
}


// MARK: - IGSEmptyCellDelegate
extension TransactionStatusVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getTransactionStatusList()
        }
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension TransactionStatusVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.transactionStatusCloseButtonDidClicked()
    }
}
