//
//  EditPhonePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/12/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//
import Alamofire

protocol EditPhoneView: ParentProtocol {
    func removeSelf()
}

class EditPhonePresenter : MKPresenter {
    
    private weak var profileView: EditPhoneView?
    private var editProfileService: EditProfileService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
    }
    
    func attachview(_ view: EditPhoneView) {
        self.profileView = view
    }
    
    func editProfile(currentPhone: String, newPhone: String, password: String)  {
        self.profileView?.showLoading()
        editProfileService?.requestEditProfilePhone(currentPhone, newPhone: newPhone, password: password, success: { [weak self] (apiResponse) in
            self?.profileView?.hideLoading()
            UserProfileManager.shared.requestProfileUser()
            self?.profileView?.showSuccessMessage?(NSLocalizedString("Profile succesfully updated", comment: ""))
            self?.profileView?.removeSelf()
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage?(error.message)
        })
    }
}
