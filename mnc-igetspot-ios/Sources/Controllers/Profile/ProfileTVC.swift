//
//  ProfileTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import DKImagePickerController
import DKCamera
import SwiftMessages

class ProfileTVC : MKTableViewController {
    
    var section = MKTableViewSection()
    var headerCell : ProfileHeaderTVCell!
    var listMenuCell = [ProfileMenuTVCell]()
    var tapGesture: UITapGestureRecognizer!
    let listName = ["Edit Profile", "Address", "Bank Account", "Phone Number", "Email", "Password", "Notifications","Blocked Account"]
    var signOutCell : ProfileEditButtonCell!
    var deactivateCell : DeactivateCell!
    var mPresenter = EditProfilePresenter()
    var user: UserData?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupTableViewStyles() {
        super.setupTableViewStyles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.mPresenter.attachview(self)
        UserProfileManager.shared.requestProfileUser()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUIData), name:NSNotification.Name(kRefreshDataUserProfileNotificationName), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
        refreshUIData()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Profile", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        
        contentView.registeredCellIdentifiers.append(R.nib.profileHeaderTVCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.profileMenuTVCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.profileEditButtonCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.deactivateCell.name)
    }
    
    override func createSections() {
        super.createSections()
        
        contentView.appendSection(section)
        contentView.reloadData()
    }
    
    @objc func refreshUIData() {
        if let user = UserProfileManager.shared.getUser() {
            setUserProfile(user: user)
        }
    }
    
    override func createRows() {
        super.createRows()
        createHeaderCell()
        createListMenuCell()
//        createDeactivateCell()
        createSignOutButton()
    }
    
    func createHeaderCell(){
        headerCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.profileHeaderTVCell.name) as? ProfileHeaderTVCell
        headerCell.delegate = self
        section.appendRow(cell: headerCell)
    }
    
    func createListMenuCell(){
        for row in 0...listName.count - 1 {
            
            let cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.profileMenuTVCell.name) as! ProfileMenuTVCell
            cell.profileListLabel.font = R.font.barlowRegular(size: 14)
            cell.profileListLabel.textColor = UIColor.black
            cell.intoMenuLabel.alpha = 1.0
            listMenuCell.append(cell)
            listMenuCell[row].setContent(listName: listName[row])
            section.appendRow(cell: listMenuCell[row])
            setAction(row: row)
        }
    }
    
    func createDeactivateCell () {
        
        deactivateCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.deactivateCell.name) as? DeactivateCell
        section.appendRow(cell: deactivateCell)
    }
    
    func createSignOutButton(){
        signOutCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.profileEditButtonCell.name) as? ProfileEditButtonCell
        signOutCell.delegate = self
        signOutCell.setTitle(title: "Sign Out")
        section.appendRow(cell: signOutCell)
    }
    
    func setAction (row: Int){
        listMenuCell[row].isUserInteractionEnabled = true
        switch row {
        case 0:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfilePressed(_:))))
        case 1:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editAddressPressed(_:))))
        case 2:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editBankPressed(_:))))
        case 3:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhonePressed(_:))))
        case 4:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editEmailPressed(_:))))
        case 5:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPasswordPressed(_:))))
        case 6:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationPressed(_:))))
        case 7:
            listMenuCell[row].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blockedAccountPressed(_:))))
        default: break
            //
        }
    }
    
    func setUserProfile(user: UserData) {
        self.user = user
        headerCell.setContent(user: user)
    }
    
    
    @objc func editProfilePressed(_ sender: UITapGestureRecognizer) {
        guard let user = self.user else {
            return
        }
        let editProfileVC = EditProfileBasicVC()
        editProfileVC.setEditProfileData(firstname : user.firstname, lastname: user.lastname, username: user.username, birthdate:  user.birthDate)
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc func editPhonePressed(_ sender: UITapGestureRecognizer) {
        guard let user = self.user else {
            return
        }
        let editPhoneVC = EditProfilePhoneVC()
        editPhoneVC.setEditProfileData(currentPhone: user.phone)
        self.navigationController?.pushViewController(editPhoneVC, animated: true)
    }
    
    @objc func editAddressPressed(_ sender: UITapGestureRecognizer) {
        let editProfileAddressVC = EditProfileAddressVC()
        editProfileAddressVC.user = self.user
        self.navigationController?.pushViewController(editProfileAddressVC, animated: true)
    }
    
    @objc func editEmailPressed(_ sender: UITapGestureRecognizer){
        guard let user = self.user else {
            return
        }
        let editEmailVC = EditProfileEmailVC()
        editEmailVC.setEditProfileData(currentEmail : user.email)
        self.navigationController?.pushViewController(editEmailVC, animated: true)
    }
    
    @objc func editPasswordPressed(_ sender: UITapGestureRecognizer){
        self.navigationController?.pushViewController(EditProfilePasswordVC(), animated: true)
    }
    
    @objc func editBankPressed(_ sender: UITapGestureRecognizer) {
        let editBankVC = EditProfileBankVC()
        self.navigationController?.pushViewController(editBankVC, animated: true)
    }
    
    @objc func notificationPressed(_ sender: UITapGestureRecognizer){
        self.navigationController?.pushViewController(EditProfileNotificationVC(), animated: true)
    }
    
    @objc func blockedAccountPressed(_ sender: UITapGestureRecognizer){
        self.navigationController?.pushViewController(EditProfileBlockedVC(), animated: true)
    }
    func onSuccessSignedOut(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showPicker (isForAvatar:Bool) {
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.autoCloseOnSingleSelect = false
        pickerController.showsCancelButton = true
        pickerController.UIDelegate = CustomUIDKImagePickerDelegate()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image, info) in
                    if let img = image {
                        if isForAvatar {
                            self.mPresenter.uploadAvatar(image: img)
                        } else {
                            self.mPresenter.uploadBackgroundProfile(image: img)
                        }
                        
                    }
                }
            }
        }
        self.present(pickerController, animated: true) {}
    }

    
    func reloadAvatar(image: String){
        headerCell.setProfilePhoto(image: image)
    }
    
    func reloadBackground(image: String){
        headerCell.setBackground(image: image)
    }
    
    func successDeactivate(){
        self.showSuccessMessageBanner("Your account has been deactivated")
    }
}

extension ProfileTVC : ProfileHeaderTVCellDelegate {
    func onProfilePhotoPressed() {
        showPicker(isForAvatar: true)
    }
    
    func onBackgroundPressed() {
        showPicker(isForAvatar: false)
    }
}

extension ProfileTVC : ProfileEditButtonCellDelegate {
    func onButtonPressed() {
//        if (self.deactivateCell.getSwitchValue()){
//            showAlertMessage(title: NSLocalizedString("Deactivate Account", comment: ""), message: NSLocalizedString("Are you sure you want to deactivate your account?", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Yes", comment: ""), okAction: { [weak self] in
//                SwiftMessages.hide()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self?.mPresenter.deactivateAccount()
//                }
//                }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
//                    SwiftMessages.hide()
//            })
//        } else {
            showAlertMessage(title: NSLocalizedString("Sign out", comment: ""), message: NSLocalizedString("Are you sure you want to Sign out?", comment:""), iconImage: nil, okButtonTitle: NSLocalizedString("Sign out", comment: ""), okAction: { [weak self] in
                SwiftMessages.hide()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.mPresenter.signOut()
                }
                }, cancelButtonTitle: NSLocalizedString("Cancel", comment: ""), cancelAction: {
                    SwiftMessages.hide()
            })
//        }
    
    }
}


extension ProfileTVC : EditProfileView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showSuccessMessage(_ message: String) {
        showSuccessMessageBanner(message)
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
}
