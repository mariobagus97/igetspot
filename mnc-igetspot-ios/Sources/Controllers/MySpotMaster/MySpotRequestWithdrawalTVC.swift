////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SwiftMessages

let kRequestWithdrawalSuccesNotificationName = "RequestWithdrawalSuccesNotification"

class MySpotRequestWithdrawalTVC: MKTableViewController {
    
    var loadingCell: LoadingCell!
    var emptyCell: IGSEmptyCell!
    var balanceCell: BalanceCell!
    var bankAccountCell: BankAccountCell!
    var bankInfoCell: MySpotBankCell!
    var withdrawalAmountCell: InputFormCell!
    var passwordCell: InputFormCell!
    var descriptionCell: WithdrawalDescriptionCell!
    var withdrawCell: RequestWithdrawalCell!
    var contentSection: MKTableViewSection!
    var presenter = MySpotRequestWithdrawalPresenter()
    var mySpotBalance: MySpotBalance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        registerForKeyboardWillShowNotification(contentView.tableView)
        registerForKeyboardWillHideNotification(contentView.tableView)
        setupNavigationBar()
        presenter.attachview(self)
        setContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.loadingCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.emptyCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.balanceCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.bankAccountCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.mySpotBankCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.inputFormCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.withdrawalDescriptionCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.requestWithdrawalCell.name)
    }
    
    override func createSections() {
        super.createSections()
        contentSection = MKTableViewSection()
        contentView.appendSection(contentSection)
    }
    
    override func createRows() {
        super.createRows()
        createBalanceCell()
        createBankAccountCell()
        createMySpotBankCell()
        createWithdrawalAmountCell()
        createInputPasswordCell()
        createWithdrawalDescriptionCell()
        createRequestWithdrawalCell()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Request Withdrawal", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }

    // MARK: - Private Functions
    private func createLoadingCell() {
        loadingCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.loadingCell.name) as? LoadingCell
    }
    
    private func createEmptyCell() {
        emptyCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.igsEmptyCell.name) as? IGSEmptyCell
    }
    
    private func createBalanceCell() {
        balanceCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.balanceCell.name) as? BalanceCell
    }
    
    private func createBankAccountCell() {
        bankAccountCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.bankAccountCell.name) as? BankAccountCell
    }
    
    private func createMySpotBankCell() {
        bankInfoCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotBankCell.name) as? MySpotBankCell
        bankInfoCell.separatorLeadingConstraint.constant = 0
        bankInfoCell.editBankButton.alpha = 0.0
    }
    
    private func createWithdrawalAmountCell() {
        withdrawalAmountCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.inputFormCell.name) as? InputFormCell
        withdrawalAmountCell.titleLabel.text = NSLocalizedString("Withdrawal Amount", comment: "")
        withdrawalAmountCell.valueTextField.placeholder = "Rp 10.000.000"
        withdrawalAmountCell.valueTextField.delegate = self
    }
    
    private func createInputPasswordCell() {
        passwordCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.inputFormCell.name) as? InputFormCell
        passwordCell.titleLabel.text = NSLocalizedString("Password", comment: "")
        passwordCell.valueTextField.placeholder = NSLocalizedString("XXXXXX", comment: "")
        passwordCell.valueTextField.isSecureTextEntry = true
        passwordCell.valueTextField.keyboardType = .default
    }
    
    private func createWithdrawalDescriptionCell() {
        descriptionCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.withdrawalDescriptionCell.name) as? WithdrawalDescriptionCell
    }
    
    private func createRequestWithdrawalCell() {
        withdrawCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.requestWithdrawalCell.name) as? RequestWithdrawalCell
        withdrawCell.requestWithdrawalButton.setTitle(NSLocalizedString("Withdraw", comment: ""), for: .normal)
        withdrawCell.delegate = self
    }
    
    func setContent() {
        contentSection.removeAllRows()
        contentSection.appendRow(cell: balanceCell)
        contentSection.appendRow(cell: bankAccountCell)
        contentSection.appendRow(cell: withdrawalAmountCell)
        contentSection.appendRow(cell: passwordCell)
        contentSection.appendRow(cell: descriptionCell)
        contentSection.appendRow(cell: withdrawCell)
        
        let balance = mySpotBalance?.balance ?? "0"
        balanceCell.setContent(balance: balance, date: "Today")
        
        let bankAccountHolder = mySpotBalance?.bankAccountHolder ?? ""
        let bankAccountNumber = mySpotBalance?.bankAccountNumber ?? ""
        let bankName = mySpotBalance?.bankName ?? ""
        bankAccountCell.setContent(accountHolderName: bankAccountHolder, accountBankNumber: bankAccountNumber, bankName: bankName)
        
        contentView.reloadData()
    }
    
    func processRequestWithdrawal(amount:String, password:String) {
        presenter.requestWithdrawal(amount: amount, password: password)
    }
}

// MARK: - MySpotRequestWithdrawalView
extension MySpotRequestWithdrawalTVC: MySpotRequestWithdrawalView {
    func showLoadingProcessWithdrawal() {
        showLoadingHUD()
    }
    
    func hideLoadingProcessWithdrawal() {
        hideLoadingHUD()
    }
    
    func handleErrorRequestWithDrawal(errorMessage:String) {
        self.showAlertMessage(title: NSLocalizedString("Withdrawal Error", comment: ""), message:errorMessage, iconImage: nil, okButtonTitle: nil, okAction:nil, cancelButtonTitle: NSLocalizedString("Ok", comment: ""), cancelAction: {
            SwiftMessages.hide()
        })
    }
    
    func handleSuccessRequestWithDrawal() {
        UserProfileManager.shared.requestProfileUser()
        NotificationCenter.default.post(name: NSNotification.Name(kRequestWithdrawalSuccesNotificationName), object: nil)
        self.showAlertMessage(title: NSLocalizedString("Withdrawal Success", comment: ""), message:NSLocalizedString("Your withdrawal request successfully submitted, we will process this shortly", comment: ""), iconImage: nil, okButtonTitle: nil, okAction:nil, cancelButtonTitle: NSLocalizedString("Ok", comment: ""), cancelAction: {
            SwiftMessages.hide()
            self.navigationController?.popViewController(animated: true)
        })
    }
}


// MARK: - RequestWithdrawalCellDelegate
extension MySpotRequestWithdrawalTVC: RequestWithdrawalCellDelegate {
    func requestWithdrawalButtonDidClicked() {
        guard let password = passwordCell.valueTextField.text, password.isEmptyOrWhitespace() == false, let amount = withdrawalAmountCell.valueTextField.text?.formatPriceToDigitString(), amount.isEmptyOrWhitespace() == false, amount != "0" else {
            showErrorMessageBanner("Please fill field amount withdrawal and your password")
            return
        }
        processRequestWithdrawal(amount: amount, password: password)
    }
}

// MARK: - UITextFieldDelegate
extension MySpotRequestWithdrawalTVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == withdrawalAmountCell.valueTextField) {
            let text: NSString = (textField.text ?? "") as NSString
            let finalString = text.replacingCharacters(in: range, with: string)
            // 'currencyOnlyDigit' is a String extension that doews all the number styling
            textField.text = "Rp \(finalString.currencyOnlyDigit)"
            
            // returning 'false' so that textfield will not be updated here, instead from styling extension
            return false
        }
        return true
    }
}
