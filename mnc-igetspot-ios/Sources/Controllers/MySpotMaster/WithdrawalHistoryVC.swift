////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CRRefresh

protocol WithdrawalHistoryVCDelegate:class  {
    func withdrawalHistoryCloseButtonDidClicked()
}

class WithdrawalHistoryVC: MKViewController, MKTableViewDelegate {

    var headerView: FloatingPanelHeaderView!
    var contentView: MKTableView!
    var presenter = WithdrawalHistoryPresenter()
    var contentSection = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    weak var delegate: WithdrawalHistoryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        presenter.attachview(self)
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.getAllWithdrawalHistory()
        }
        getAllWithdrawalHistory()
    }
    
    // MARK: - MKTableViewDelegate
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.withdrawalHistoryCell.name)
    }
    
    func createSections() {
        contentView.appendSection(contentSection)
    }
    
    func createRows() {
        
    }
    
    // MARK: - Public Funtions
    func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Withdrawal History", comment: "")
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
    
    private func getAllWithdrawalHistory() {
        guard let userId = TokenManager.shared.getUserId() else {
            return
        }
        presenter.getAllWithdrawalHistory(userId: userId)
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createWithdrawalHistoryCell() -> WithdrawalHistoryCell {
        let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.withdrawalHistoryCell.name) as! WithdrawalHistoryCell
        return cell
    }

}

// MARK: - FloatingPanelHeaderViewDelegate
extension WithdrawalHistoryVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.withdrawalHistoryCloseButtonDidClicked()
    }
}

// MARK:- WithdrawalHistoryView
extension WithdrawalHistoryVC: WithdrawalHistoryView {
    func showLoadingView() {
        if contentSection.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            contentSection.removeAllRows()
            createLoadingCell()
            contentSection.appendRow(cell: loadingCell)
            loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
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
        contentSection.removeAllRows()
        createEmptyCell()
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        contentSection.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(withdrawalHistoryArray:[WithdrawalHistory]) {
        contentSection.removeAllRows()
        for withdrawalHistory in withdrawalHistoryArray {
            let withdrawalHistoryCell = createWithdrawalHistoryCell()
            withdrawalHistoryCell.setContent(withdrawalHistory: withdrawalHistory)
            contentSection.appendRow(cell: withdrawalHistoryCell)
        }
        contentView.reloadData()
    }
}

// MARK: - IGSEmptyCellDelegate
extension WithdrawalHistoryVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            getAllWithdrawalHistory()
        }
    }
}
