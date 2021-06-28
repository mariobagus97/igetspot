//
//  EditBasicProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire
import SendBirdSDK

protocol EditBasicProfileView: ParentProtocol {
    func removeSelf()
}

class EditBasicProfilePresenter : MKPresenter {
    
    private weak var profileView: EditBasicProfileView?
    private var editProfileService: EditProfileService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
    }
    
    func attachview(_ view: EditBasicProfileView) {
        self.profileView = view
    }
    
    func editProfile(firstname: String, lastname: String, username: String, birthdate: String, password: String)  {
        self.profileView?.showLoading()
        editProfileService?.requestEditProfileBasic(firstname, lastName: lastname, username: username, birthdate: birthdate, password: password, success: { [weak self] (apiResponse) in
            let currentuser = SBDMain.getCurrentUser()
            SBDMain.updateCurrentUserInfo(withNickname: "\(firstname) \(lastname)", profileUrl: currentuser?.originalProfileUrl, completionHandler: { (error) in
                self?.profileView?.hideLoading()
                if (error != nil){
                    self?.profileView?.showErrorMessage?(error?.localizedDescription ?? "Error update profile")
                }
                UserProfileManager.shared.requestProfileUser()
                self?.profileView?.showSuccessMessage?(NSLocalizedString("Profile succesfully updated", comment: ""))
                self?.profileView?.removeSelf()
            })
            
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage?(error.message)
        })
    }
    
}
