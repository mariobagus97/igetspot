//
//  CurrencyVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 10/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CurrencyVCDelegate {
    func onSelected(currency: String)
    func hideThisPanel()
}

class CurrencyVC: MKViewController {
    
    var currencyView: CurrencyView!
    var delegate : CurrencyVCDelegate!
    var presenter = CurrencyPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        presenter.attachview(self)
        presenter.getCurrencyList()
    }
    
    func addViews() {
        currencyView  = UINib(nibName: "CurrencyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CurrencyView
        view.addSubview(currencyView)
        currencyView.delegate = self
        currencyView.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
    }
    
}

extension CurrencyVC : CurrencyViewDelegate {
    func onCurrencySelected(currencyList: [CurrencyObject], selected: Int) {
        presenter.updateCurrency(currencyList: currencyList, selected: selected)
        delegate?.onSelected(currency: currencyList[selected].currencyName)
    }
    
    func didHidePressed() {
        delegate?.hideThisPanel()
    }
}

extension CurrencyVC : CurrencyPresenterView {
    func setCurrency(currency: [CurrencyObject]) {
        self.currencyView.setContent(currencyList: currency)
    }
    
    func showLoading() {
        //
    }
    
    func hideLoading() {
        //
    }
    
    
}
