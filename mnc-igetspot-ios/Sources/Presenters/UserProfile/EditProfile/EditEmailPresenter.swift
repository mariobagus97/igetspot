//
//  EditEmailPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//
import Alamofire

protocol EditEmailView: ParentProtocol {
    func removeSelf()
}

class EditEmailPresenter : MKPresenter {
    
    private weak var profileView: EditEmailView?
    private var editProfileService: EditProfileService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
    }
    
    func attachview(_ view: EditEmailView) {
        self.profileView = view
    }
    
    func editProfile(currentEmail: String, newEmail: String, password: String)  {
        self.profileView?.showLoading()
        editProfileService?.requestEditProfileEmail(currentEmail, newEmail: newEmail, password: password, success: { [weak self] (apiResponse) in
            self?.profileView?.hideLoading()
            UserProfileManager.shared.requestProfileUser()
            self?.profileView?.showSuccessMessage?(NSLocalizedString("Profile succesfully updated", comment: ""))
//                .showSuccessMessageBanner(NSLocalizedString("Profile succesfully updated", comment: ""))
            self?.profileView?.removeSelf()
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage?(error.message)
//                self?.profileView?.showErrorMessageBanner(error.message)
        })
    }
}
