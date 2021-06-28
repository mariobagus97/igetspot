//
//  EditProfileBankVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import FloatingPanel

protocol EditProfileBankVCDelegate:class {
    func editOrAddBankSuccess()
}

class EditProfileBankVC : MKViewController {
    
    var bankPanel: FloatingPanelController?
    var editBankPresenter = EditBankPresenter()
    private let cancelButton = UIButton(type: .custom)
    var isFromMySpot = false
    let editProfileView = UINib(nibName: R.nib.editProfileBankView.name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditBankAccountPage
    var thisBankId = ""
    weak var delegate: EditProfileBankVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        addView()
        editBankPresenter.attachview(self)
        self.editBankPresenter.getUserBankDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Bank Account", comment: ""))
        if isFromMySpot {
            setupCancelBarButtonItem()
        } else {
            setupLeftBackBarButtonItems(barButtonType: .backButton)
        }
    }
    
    func setupCancelBarButtonItem() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        cancelButton.setTitleColor(Colors.blueTwo, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClicked), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    @objc func cancelButtonDidClicked() {
        self.dismiss(animated: true, completion: nil)
    }

    
    func addView(){
        self.view.addSubview(editProfileView)
        
        editProfileView.delegate = self
        
        editProfileView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func removeSelf() {
        if (isFromMySpot) {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func hidePanel(){
        if let bankPanel = self.bankPanel {
            bankPanel.dismiss(animated: true, completion: nil)
        }
    }
    
    func setContent(list: [Bank]){
        bankPanel = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        bankPanel?.surfaceView.cornerRadius = 8.0
        bankPanel?.surfaceView.shadowHidden = false
        bankPanel?.isRemovalInteractionEnabled = true
        bankPanel?.delegate = self
        
        let contentVC = ChooseBankPanelTVC()
        contentVC.setContent(list: list, bankId: self.thisBankId)
        contentVC.delegate = self
        bankPanel?.set(contentViewController: contentVC)
        self.present(bankPanel!, animated: true, completion: nil)
        
    }
    
}

extension EditProfileBankVC : EditBankAccountPageDelegate {
    func onUpdatePressed(bankId: String, bankAccountHolder: String, bankAccountNumber: String, passwordLogin: String) {
        editBankPresenter.editProfile(bankId: bankId, accountHolder: bankAccountHolder, accountNo: bankAccountNumber, password: passwordLogin)
    }
    
    func didChooseBankPressed(bankId: String){
        editBankPresenter.getBankList()
        self.thisBankId = bankId
    }
    
}

// MARK:- FloatingPanelControllerDelegate
extension EditProfileBankVC: FloatingPanelControllerDelegate {
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half]
    }
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half: return 150.0
        default: return nil  // Must return nil for .full
        }
    }
}

extension EditProfileBankVC : ChooseBankPanelTVCDelegate {
    func hideBankPanel() {
        self.hidePanel()
    }
    
    func setSelectedBank(bank: Bank) {
        self.editProfileView.setBank(bank: bank, bankId: bank.id ?? "")
        self.hidePanel()
    }
    
    
}

extension EditProfileBankVC : EditBankView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
    func editOrAddBankSuccess() {
        UserProfileManager.shared.requestProfileUser()
        showSuccessMessageBanner(NSLocalizedString("Bank succesfully updated", comment: ""))
        delegate?.editOrAddBankSuccess()
        removeSelf()
    }
    
    func setEditProfileData(bankDetail: UserBankDetail){
        self.thisBankId = bankDetail.id ?? ""
        editProfileView.showUserData(bankDetail : bankDetail)
    }
    
}
