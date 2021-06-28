//
//  CurrencyPresenter.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 15/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

protocol CurrencyPresenterView: ParentProtocol {
    func setCurrency(currency: [CurrencyObject])
}

class CurrencyPresenter: MKPresenter {
    private weak var view: CurrencyPresenterView?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: CurrencyPresenterView) {
        self.view = view
    }
    
    override func detachView() {
        self.view = nil
    }
    
    func getCurrencyList(){
        view?.setCurrency(currency: CurrencyManager.shared.getUserCurrency())
       
    }
    
    func updateCurrency(currencyList: [CurrencyObject], selected: Int){
        CurrencyManager.shared.setUserCurrency(currencyList: currencyList, selected: selected)
    }
    
}
