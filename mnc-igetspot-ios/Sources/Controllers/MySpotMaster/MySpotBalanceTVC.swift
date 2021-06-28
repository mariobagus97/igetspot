//
//  MySpotBalanceVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 17/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FloatingPanel
import CRRefresh

class MySpotBalanceTVC: MKTableViewController {

    var contentSection : MKTableViewSection!
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var amountBalanceCell: AmountBalanceCell!
    var bankCell: MySpotBankCell!
    var requestWithdrawalCell: RequestWithdrawalCell!
    private let historyButton = UIButton(type: .custom)
    var withdrawalHistoryFPC: FloatingPanelController?
    let presenter = MySpotBalancePresenter()
    var mySpotBalance: MySpotBalance?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRequestWithdrawalSuccesNotification), name:NSNotification.Name(kRequestWithdrawalSuccesNotificationName), object: nil)
        setupNavigationBar()
        contentView.tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.presenter.getBalanceDetail()
        }
        presenter.attachview(self)
        presenter.getBalanceDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - MKTableViewControllerDelegate
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.amountBalanceCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotBankCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.requestWithdrawalCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
        createAmountBalanceCell()
        createBankCell()
        createRequestWithdrawalCell()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("My Balance", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
        setupRightBarButtonItem()
    }
    
    
    // MARK: - Actions
    @objc func historyBarButtonItemDidClicked() {
        showWithdrawalHistoryFPC()
    }
    
    // MARK: - Private Functions
    @objc func handleRequestWithdrawalSuccesNotification() {
        presenter.getBalanceDetail()
    }
    
    func hideCRRefresh() {
        contentView.tableView.cr.endHeaderRefresh()
    }
    
    private func setupRightBarButtonItem() {
        historyButton.setImage(R.image.clockHistory(), for: .normal)
        historyButton.addTarget(self, action: #selector(historyBarButtonItemDidClicked), for: .touchUpInside)
        let historyBarButtonItem = UIBarButtonItem(customView: historyButton)
        navigationItem.rightBarButtonItem = historyBarButtonItem
    }
    
    private func createRequestWithdrawalCell() {
        requestWithdrawalCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.requestWithdrawalCell.name) as? RequestWithdrawalCell
        requestWithdrawalCell.requestWithdrawalButton.setTitle(NSLocalizedString("Request Withdrawal", comment: ""), for: .normal)
        requestWithdrawalCell.delegate = self
    }
    
    private func createAmountBalanceCell() {
        amountBalanceCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.amountBalanceCell.name) as? AmountBalanceCell
    }
    
    private func createBankCell() {
        bankCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotBankCell.name) as? MySpotBankCell
        bankCell.delegate = self
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
        emptyCell.delegate = self
    }
    
    private func showWithdrawalHistoryFPC() {
        withdrawalHistoryFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        withdrawalHistoryFPC?.surfaceView.cornerRadius = 8.0
        withdrawalHistoryFPC?.surfaceView.shadowHidden = false
        withdrawalHistoryFPC?.isRemovalInteractionEnabled = true
        withdrawalHistoryFPC?.delegate = self
        
        let contentVC = WithdrawalHistoryVC()
        contentVC.delegate = self
        
        // Set a content view controller
        withdrawalHistoryFPC?.set(contentViewController: contentVC)
        present(withdrawalHistoryFPC!, animated: true, completion: nil)
    }
    
    private func hideWithdrawalHistoryFPC(animated:Bool) {
        if let withdrawalHistoryFPC = self.withdrawalHistoryFPC {
            withdrawalHistoryFPC.dismiss(animated: animated, completion: nil)
        }
    }
    
    // MARK: - Public Functions
    

}

// MARK: - MySpotBankCellDelegate
extension MySpotBalanceTVC: MySpotBankCellDelegate {
    func editBankButtonDidClicked() {
        let editBankVC = EditProfileBankVC()
        editBankVC.isFromMySpot = true
        editBankVC.delegate = self
        let navigationController = UINavigationController(rootViewController: editBankVC)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - EditProfileBankVCDelegate
extension MySpotBalanceTVC: EditProfileBankVCDelegate {
    func editOrAddBankSuccess() {
        presenter.getBalanceDetail()
    }
}

// MARK: - RequestWithdrawalCellDelegate
extension MySpotBalanceTVC: RequestWithdrawalCellDelegate {
    func requestWithdrawalButtonDidClicked() {
        let requestWithdrawalTVC = MySpotRequestWithdrawalTVC()
        requestWithdrawalTVC.mySpotBalance = self.mySpotBalance
        navigationController?.pushViewController(requestWithdrawalTVC, animated: true)
    }
}

// MARK:- FloatingPanelControllerDelegate
extension MySpotBalanceTVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == withdrawalHistoryFPC {
            return FullPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if vc == withdrawalHistoryFPC {
            withdrawalHistoryFPC = nil
        }
    }
}

// MARK:- WithdrawalHistoryVCDelegate
extension MySpotBalanceTVC: WithdrawalHistoryVCDelegate {
    func withdrawalHistoryCloseButtonDidClicked() {
        hideWithdrawalHistoryFPC(animated: true)
    }
}

// MARK:- MySpotBalanceView
extension MySpotBalanceTVC: MySpotBalanceView {
    func setContent(mySpotBalance: MySpotBalance) {
        self.mySpotBalance = mySpotBalance
        contentSection.removeAllRows()
        contentSection.appendRow(cell: amountBalanceCell)
        amountBalanceCell.totalBalanceLabel.text = mySpotBalance.balance?.currency
        contentSection.appendRow(cell: bankCell)
        var isDataBankEmpty = false
        if let accountHolder = mySpotBalance.bankAccountHolder, accountHolder.isEmptyOrWhitespace() == false, let accountNumber = mySpotBalance.bankAccountNumber, accountNumber.isEmptyOrWhitespace() == false, let bankName = mySpotBalance.bankName, bankName.isEmptyOrWhitespace() == false {
            bankCell.setContent(bankBranch: "", bankAccountHolder: accountHolder, bankName: bankName, bankAccountNumber: accountNumber)
        } else {
            isDataBankEmpty = true
            bankCell.setEmptyBankData()
        }
        
        if (mySpotBalance.balance != "0" && isDataBankEmpty == false) {
            contentSection.appendRow(cell: requestWithdrawalCell)
        }
        
        contentView.reloadData()
    }
    
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
}

// MARK: - IGSEmptyCellDelegate
extension MySpotBalanceTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            presenter.getBalanceDetail()
        }
    }
}
