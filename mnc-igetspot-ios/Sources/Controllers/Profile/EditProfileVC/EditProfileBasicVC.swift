//
//  EditProfileBasicVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import FloatingPanel

class EditProfileBasicVC : MKViewController {
    
    var editBasicProfilePresenter = EditBasicProfilePresenter()
    let editProfileView = UINib(nibName: R.nib.editProfileBasicView.name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfileBasicPage
    var selectCalendarFPC : FloatingPanelController!
    var birthdate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        editBasicProfilePresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Edit Profile", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func addView(){
        self.view.addSubview(editProfileView)
        
        editProfileView.delegate = self
        
        editProfileView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func setEditProfileData(firstname: String, lastname: String, username: String, birthdate: String){
        self.birthdate = birthdate
        editProfileView.showUserData(firstname: firstname, lastname: lastname, username: username, birthdate: birthdate)
    }
    
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    private func showSelectCalendar(currentDate:Date?) {
        selectCalendarFPC = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        selectCalendarFPC?.surfaceView.cornerRadius = 8.0
        selectCalendarFPC?.surfaceView.shadowHidden = false
        selectCalendarFPC?.isRemovalInteractionEnabled = true
        selectCalendarFPC?.delegate = self
        
        let contentVC = OrderDetailCalendarVC()
        contentVC.currentDate = currentDate
        contentVC.delegate = self
        contentVC.changeableYear = true
        contentVC.birthDate = self.birthdate
        // Set a content view controller
        selectCalendarFPC?.set(contentViewController: contentVC)
        self.present(selectCalendarFPC!, animated: true, completion: nil)
    }
    
    private func hideSelectCalendarFPC(animated:Bool) {
        if let selectCalendarFPC = self.selectCalendarFPC {
            selectCalendarFPC.dismiss(animated: animated, completion: nil)
        }
    }
    
}

extension EditProfileBasicVC : EditProfileBasicPageDelegate {
    
    func onUpdatePressed(firstname: String, lastname: String, username: String, birthdate: String, password: String) {
        editBasicProfilePresenter.editProfile(firstname: firstname, lastname: lastname, username: username, birthdate: birthdate, password: password)
    }
    
    func onBirthdatePressed(){
        let currentDate = editProfileView.getCurrentDate()
        showSelectCalendar(currentDate: currentDate)
    }

}

extension EditProfileBasicVC : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return IntrinsicPanelLayout()
    }
}

// MARK:- OrderDetailCalendarVCDelegate
extension EditProfileBasicVC: OrderDetailCalendarVCDelegate {
    func closeCalanderButtonDidClicked() {
        hideSelectCalendarFPC(animated: true)
    }
    
    func selectDateCalendarDidClicked(selectedDate:Date?) {
        hideSelectCalendarFPC(animated: true)
        guard let date = selectedDate else {
//            editProfileView.setBirthdateText(dateString: date)
            return
        }
        editProfileView.setBirthdateText(dateString: date.toFormat("yyyy-MM-dd"))
       
    }
}

extension EditProfileBasicVC : EditBasicProfileView {
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
