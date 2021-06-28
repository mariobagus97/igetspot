//
//  EditProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

protocol EditProfileView:ParentProtocol {
    
}

class EditProfilePresenter : MKPresenter {
    
    private weak var view: EditProfileView?
    private var editProfileService: EditProfileService?
    
    
    private var tokenService: TokenService?
    private var signOutService : SignOutService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
        tokenService = TokenService()
        signOutService = SignOutService()
    }
    
    func attachview(_ view: EditProfileView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func uploadAvatar(image: UIImage){
        self.view?.showLoading()
        editProfileService?.requestEditProfileAvatar(image, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let imageUrl = apiResponse.data.stringValue
            SDWebImageHelper.removeCacheForIGSImageUrl(imageUrl: imageUrl)
            UserProfileManager.shared.requestProfileUser()
            self?.view?.showSuccessMessage?(NSLocalizedString("Profile has been updated", comment: ""))
//            self?.view?.showSuccessMessageBanner(NSLocalizedString("Profile has been updated", comment: ""))
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
    
    func uploadBackgroundProfile(image: UIImage) {
        
        self.view?.showLoading()
        editProfileService?.requestEditProfileBackgroundImage(image, success: { [weak self] (apiResponse) in
            self?.view?.hideLoading()
            let imageUrl = apiResponse.data.stringValue
            SDWebImageHelper.removeCacheForIGSImageUrl(imageUrl: imageUrl)
            UserProfileManager.shared.requestProfileUser()
            self?.view?.showSuccessMessage?(NSLocalizedString("Profile has been updated", comment: ""))
            }, failure: {[weak self] (error) in
                self?.view?.hideLoading()
                self?.view?.showErrorMessage?(error.message)
        })
    }
    
    
    func signOut() {
        self.view?.showLoading()
        signOutService?.signOut(success: {[weak self] (apiResponse) in
            self?.view?.hideLoading()
            TokenManager.shared.logOut()
            }, failure: { [weak self] (error) in
                self?.view?.hideLoading()
                TokenManager.shared.logOut()
        })
    }
    
    func deactivateAccount(){
        self.view?.showLoading()
        editProfileService?.deactivateAccount(success: {[weak self] (apiResponse) in
            self?.view?.hideLoading()
            TokenManager.shared.logOut(isDeactivated: true)
            }, failure:  { [weak self] (error) in
                self?.view?.showErrorMessage?("Your account has been already inactivated")
                self?.view?.hideLoading()
        })
    }
}

