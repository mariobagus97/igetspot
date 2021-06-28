//
//  SettingPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/19/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SettingPageDelegate {
    func didCurrencyViewPresed()
}

class SettingPage: UIView {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyView: UIView!
    
    var delegate : SettingPageDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        addGesture()
    }
    
    func addGesture(){
        currencyView.isUserInteractionEnabled = true
        currencyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCurrencyViewPresed(_:))))
    }
    
    @objc func onCurrencyViewPresed(_ sender: UITapGestureRecognizer){
        self.delegate?.didCurrencyViewPresed()
    }
    
    func setCurrency(currency: String){
        self.currencyLabel.text = currency
    }
    
    
}
