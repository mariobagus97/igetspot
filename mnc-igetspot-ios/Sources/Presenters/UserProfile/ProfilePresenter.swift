//
//  ProfilePresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/26/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class ProfilePresenter: MKPresenter {
    private weak var view: ProfileTVC?
    private var editProfileService: EditProfileService?
    
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
      
    }
    
    func attachview(_ view: ProfileTVC) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func uploadAvatar(image: UIImage){
        self.view?.showLoadingHUD()
        editProfileService?.requestEditProfileAvatar(image, success: { [weak self] (apiResponse) in
            self?.view?.hideLoadingHUD()
            UserProfileManager.shared.requestProfileUser()
            }, failure: {[weak self] (error) in
                self?.view?.hideLoadingHUD()
                self?.view?.showErrorMessageBanner(error.message)
        })
    }

    
}
