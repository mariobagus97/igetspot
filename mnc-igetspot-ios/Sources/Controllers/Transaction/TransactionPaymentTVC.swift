//
//  TransactionPaymentTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FloatingPanel

protocol TransactionPaymentTVCDelegate:class {
    func redirectToActiveTab()
}

class TransactionPaymentTVC : MKTableViewController {
    
    var mPresenter = TransactionPaymentPresenter()
    var section: MKTableViewSection!
    var bankCell : PaymentBankCell!
    var payCell : PaymentPayCell!
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var virtualAccountVC: FloatingPanelController?
    
    var orderId : String?
    var subtotal : String?
    var invoiceID: String?
    
    weak var delegate: TransactionPaymentTVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mPresenter.attachview(self)
        mPresenter.getBank()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Payment",comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.paymentBankCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.paymentPayCell.name)
    }
    
    override func createSections() {
        super.createSections()
        section = MKTableViewSection()
        contentView.appendSection(section)
        contentView.reloadData()
    }
    
    override func createRows() {
        super.createRows()
    }
    
    // MARK: - Publics Functions
    
    
    // MARK: - Private Functions
    private func hideVA() {
        if let virtualAccountVC = self.virtualAccountVC {
            virtualAccountVC.dismiss(animated: true, completion: nil)
        }
        delegate?.redirectToActiveTab()
        navigationController?.popViewController(animated: false)
    }
    
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createBankCell() {
        bankCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.paymentBankCell.name) as? PaymentBankCell
        section.appendRow(cell: bankCell)
    }
    
    private func createPayCell(){
        payCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.paymentPayCell.name) as? PaymentPayCell
        section.appendRow(cell: payCell)
        payCell.delegate = self
    }
}

extension TransactionPaymentTVC: TransactionPaymentView {
    
    func showTransactionLoadingHUD() {
        showLoadingHUD()
    }
    
    func hideTransactionLoadingHUD() {
        hideLoadingHUD()
    }
    
    func showMessageError(message: String) {
        showErrorMessageBanner(message)
    }
    
    func showPaymentLoadingView() {
        if section.numberOfRows() == 0 {
            section.removeAllRows()
            createLoadingCell()
            section.appendRow(cell: loadingCell)
            loadingCell.updateHeight(self.view.bounds.height - self.topbarHeight)
            loadingCell.loadingIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.contentView.reloadData()
            }
        }
    }
    
    func hidePaymentLoadingView() {
        contentView.scrollEnabled(true)
        section.removeAllRows()
    }
    
    func showEmptyView(withMessage message:String, description:String?, buttonTitle:String?, emptyCellButtonType:EmtypCellButtonType?) {
        section.removeAllRows()
        createEmptyCell()
        emptyCell.delegate = self
        emptyCell.setContent(withTitle: message, description: description, buttonTitle: buttonTitle, buttonType: emptyCellButtonType)
        section.appendRow(cell: emptyCell)
        contentView.reloadData()
    }
    
    func setBank(bankList: [Bank]) {
        createBankCell()
        createPayCell()
        
        if let subtotalprice = self.subtotal {
            payCell.setContent(total: subtotalprice)
        }
        bankCell.setContent(list: bankList)
        contentView.reloadData()
    }
    
    func showVA(txId: String){
        virtualAccountVC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        virtualAccountVC?.surfaceView.cornerRadius = 8.0
        virtualAccountVC?.surfaceView.shadowHidden = false
        virtualAccountVC?.isRemovalInteractionEnabled = true
        virtualAccountVC?.panGestureRecognizer.isEnabled = true
        virtualAccountVC?.delegate = self
        
        let contentVC = TransactionVirtualAccountTVC()
        contentVC.txId = txId
        contentVC.delegate = self
        
        // Set a content view controller
        virtualAccountVC?.set(contentViewController: contentVC)
        
        //  Add FloatingPanel to self.view
        present(virtualAccountVC!, animated: true, completion: nil)
    }
    
    
    func hasCompletedProfile() {
        if let bank = bankCell.selectedBank, let invoiceId = self.invoiceID , let order = orderId{
            mPresenter.getVA(orderID: order,invoiceID: invoiceId, paymentMethod: "02", bankCode: bank.bankCode ?? "0")
        } else {
            showErrorMessageBanner(NSLocalizedString("Oops, something went wrong, please try again", comment: ""))
        }
    }
   
}

extension TransactionPaymentTVC: IGSEmptyCellDelegate {
    func buttonDidClicked(withButtonType buttonType:EmtypCellButtonType?) {
        if (buttonType == .error) {
            mPresenter.getBank()
        }
    }
}

extension TransactionPaymentTVC : PaymentPayCellDelegate {
    func didPayPressed() {
//        virtualAccountVC = FloatingPanelController()
//
//        // Initialize FloatingPanelController and add the view
//        virtualAccountVC?.surfaceView.cornerRadius = 8.0
//        virtualAccountVC?.surfaceView.shadowHidden = false
//        virtualAccountVC?.isRemovalInteractionEnabled = true
//        virtualAccountVC?.panGestureRecognizer.isEnabled = true
//        virtualAccountVC?.delegate = self
//
//        let contentVC = PaymentInstructionVC()
//
//        // Set a content view controller
//        virtualAccountVC?.set(contentViewController: contentVC)
//
//        //  Add FloatingPanel to self.view
//        present(virtualAccountVC!, animated: true, completion: nil)
        mPresenter.profileHasBeenCompleted()
    }
  
}

extension TransactionPaymentTVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == virtualAccountVC {
            return FullPanelLayout()
        }
        return nil
    }
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        hideVA()
    }
}

extension TransactionPaymentTVC : TransactionVirtualAccountTVCDelegate{
    func closePanel() {
        hideVA()
    }
}
