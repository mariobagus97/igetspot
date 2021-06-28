//
//  EditNotificationPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol EditNotificationView: ParentProtocol {
    
}

class EditNotificationPresenter : MKPresenter {
    
    private weak var profileView: EditNotificationView?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: EditNotificationView) {
        self.profileView = view
    }
    
    func editProfile(emailNotif: Bool, smsNotif: Bool, whatsappNotif: Bool, phone: Bool)  {
       
    }
    
}

