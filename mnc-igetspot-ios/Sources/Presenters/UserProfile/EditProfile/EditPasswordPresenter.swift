//
//  EditPasswordPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol EditPasswordView: ParentProtocol {
    func removeSelf()
}

class EditPasswordPresenter : MKPresenter {
    
    private weak var profileView: EditPasswordView?
    private var editProfileService: EditProfileService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
    }
    
    func attachview(_ view: EditPasswordView) {
        self.profileView = view
    }
    
    func editProfile(currentPassword: String, newPassword: String, newPassword2: String)  {
        editProfileService?.requestEditProfilePassword(currentPassword, newPassword: newPassword, retypePassword: newPassword2, success: { [weak self] (apiResponse) in
            self?.profileView?.hideLoading()
            UserProfileManager.shared.requestProfileUser()
            self?.profileView?.showSuccessMessage?(NSLocalizedString("Profile succesfully updated", comment: ""))
            self?.profileView?.removeSelf()
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage?(error.message)
        })
    }
    
    func updateUserDefaults(){
        
    }
}
