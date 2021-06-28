//
//  TransactionVirtualAccountTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/25/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

protocol TransactionVirtualAccountTVCDelegate : class {
    func closePanel()
}

class TransactionVirtualAccountTVC: MKViewController, MKTableViewDelegate {
    
    var headerView: FloatingPanelHeaderView!
    var contentView: MKTableView!
    var section = MKTableViewSection()
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    let mPresenter = TransactionVirtualPresenter()
    var transaction : TransactionDetail!
    var thankYouCell : TransactionThankYouCell!
    var detailCell : TransactionDetailCell!
    var paymentConfirmCell : TransactionPaymentConfirmCell!
    var yourTransactionCell : YourTransactionDetail!
    var transactionDotCell : TransactionDotListCell!
    var totalCell : TransactionTotalCell!
    weak var delegate: TransactionVirtualAccountTVCDelegate?
    var txId : String?
    var isFromPushNotifications = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        mPresenter.attachview(self)
        mPresenter.getVANumber(txId: self.txId!)
    }
    
    // MARK: - MKTableViewDelegate
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.igsEmptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionDetailCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionDotListCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionThankYouCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.yourTransactionDetail.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionPaymentConfirmCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.transactionTotalCell.name)
    }
    
    func createSections() {
        contentView.appendSection(section)
        contentView.reloadData()
    }
    
    func createRows() {
        
    }
    
    // MARK: - Public Funtions
    
    
    func removeAllRows() {
        section.removeAllRows()
    }
    
    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Payment", comment: "")
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
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createThankYouCell() {
        thankYouCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionThankYouCell.name) as? TransactionThankYouCell
        section.appendRow(cell: thankYouCell)
    }
    
    private func createPaymentConfirmCell() {
        paymentConfirmCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionPaymentConfirmCell.name) as? TransactionPaymentConfirmCell
        section.appendRow(cell: paymentConfirmCell)
    }
    
    private func createYourTransactionDetailCell(){
        yourTransactionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.yourTransactionDetail.name) as? YourTransactionDetail
        section.appendRow(cell: yourTransactionCell)
    }
    
    private func createDotListCell() {
        transactionDotCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionDotListCell.name) as? TransactionDotListCell
        section.appendRow(cell: transactionDotCell)
    }
    
    private func createTotalCell() {
        totalCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionTotalCell.name) as? TransactionTotalCell
        totalCell.delegate = self
        section.appendRow(cell: totalCell)
    }
}

// MARK: -
extension TransactionVirtualAccountTVC: TransactionVirtualAccountView {
    func showLoadingView() {
        if section.numberOfRows() == 0 {
            contentView.scrollEnabled(false)
            section.removeAllRows()
            createLoadingCell()
            section.appendRow(cell: loadingCell)
            loadingCell.updateHeight(100)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.contentView.reloadData()
            }
        }
    }
    
    func hideLoadingView() {
        contentView.scrollEnabled(true)
        section.removeAllRows()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        createEmptyCell()
        section.appendRow(cell: emptyCell)
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setContent(data : TransactionVirtualAccount) {
        createThankYouCell()
        thankYouCell.setContent(invoiceId: data.invoiceId ?? "", userName: data.userName ?? "", userEmail: data.userEmail ?? "", isFromPushNotifications: isFromPushNotifications)
        
        createDotListCell()
        transactionDotCell.setLabel(textString: "Punya pertanyaan? Kamu bisa menghubungi i Get Spot dengan mengirimkan email ke cs@igetspot.com atau telepon ke +62 21 7303312", boldTextArray: ["cs@igetspot.com", "+62 21 7303312"])
        
        createDotListCell()
        transactionDotCell.setLabel(textString: "Email konfirmasi sudah dikirimkan ke " + data.userEmail!, boldTextArray: [data.userEmail!])
        
        if (isFromPushNotifications == false) {
            createPaymentConfirmCell()
            paymentConfirmCell.setContent(duedate: data.vaExpiredDateString ?? "", accountNo: data.vaNo ?? "", bankName: data.bankName ?? "")
        }
        
        if let transactionDetailArray = data.transactionDetailArray, transactionDetailArray.count > 0 {
            createYourTransactionDetailCell()
            yourTransactionCell.setContent(transactionList: transactionDetailArray)
        }
        
        createTotalCell()
        totalCell.setContent(subtotal: data.paymentAmount ?? "0", total: data.paymentAmount ?? "0")
        contentView.reloadData()
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension TransactionVirtualAccountTVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.closePanel()
    }
}

// MARK: - IGSEmptyCellDelegate
extension TransactionVirtualAccountTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType: EmtypCellButtonType?) {
        if (buttonType == .error) {
            //            getTransactionActiveList()
        } else {
            //            delegate?.requestStartOrderButtonDidClicked()
        }
    }
}

// MARK: - TransactionTotalCellDelegate
extension TransactionVirtualAccountTVC : TransactionTotalCellDelegate {
    func onBackButtonPressed() {
        delegate?.closePanel()
    }
}
