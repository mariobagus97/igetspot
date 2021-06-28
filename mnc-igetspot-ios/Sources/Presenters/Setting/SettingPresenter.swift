//
//  SettingPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 16/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol SettingView: ParentProtocol {
    func setCurrency(currency: CurrencyObject)
}

class SettingPresenter: MKPresenter {
    private weak var view: SettingView?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: SettingView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func initCurrency(){
        CurrencyManager.shared.initCurrency()
        view?.setCurrency(currency:CurrencyManager.shared.getChosenCurrency())
        
    }
}
