//
//  EditAddressPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/9/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Alamofire

protocol EditAddressView: ParentProtocol {
    func removeSelf()
}

class EditAddressPresenter : MKPresenter {
    
    private weak var profileView: EditAddressView?
    private var editProfileService: EditProfileService?
    
    override init() {
        super.init()
        editProfileService = EditProfileService()
    }
    
    func attachview(_ view: EditAddressView) {
        self.profileView = view
        
    }
    
    func editAddress(address: String, latitude: Double, longitude: Double, detail: String, country: String, city: String, province: String, zipcode: String, password: String) {
        self.profileView?.showLoading()
        editProfileService?.requestEditProfileAddress(address, latitude: latitude, longitude: longitude, detail: detail, country: country, city: city, province: province, postcode: zipcode, password: password, success: { [weak self] (apiResponse) in
            self?.profileView?.hideLoading()
            UserProfileManager.shared.requestProfileUser()
            self?.profileView?.showSuccessMessage!(NSLocalizedString("Profile adress succesfully updated", comment: ""))
//            self?.profileView?.showSuccessMessageBanner(NSLocalizedString("Profile adress succesfully updated", comment: ""))
            self?.profileView?.removeSelf()
            }, failure: {[weak self] (error) in
                self?.profileView?.hideLoading()
                self?.profileView?.showErrorMessage!(error.message)
        })
    }
}
