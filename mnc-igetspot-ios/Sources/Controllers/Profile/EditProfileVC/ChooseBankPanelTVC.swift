//
//  ChooseBankPanelTVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 08/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ChooseBankPanelTVCDelegate {
    func hideBankPanel()
    func setSelectedBank(bank: Bank)
}

class ChooseBankPanelTVC: MKViewController {
    
    var bankPage: EditBankListPage!
    var bankList : [Bank]?
    var delegate : ChooseBankPanelTVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    func addViews() {
        bankPage = UINib(nibName: "EditBankListPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditBankListPage
        view.addSubview(bankPage)
        bankPage.delegate = self
        bankPage.snp.makeConstraints{ (make) in
            make.bottom.top.left.right.equalTo(self.view)
        }
    }
    
    
    func setContent(list : [Bank], bankId: String){
        
        self.bankList = list
        if (bankPage == nil){
            addViews()
        }
        bankPage.setContent(bankList: list, bankId: bankId)
    }
    
}

extension ChooseBankPanelTVC : EditBankListPageDelegate {
    func didHidePressed() {
        delegate?.hideBankPanel()
    }
    
    func setBank(bank: Bank) {
        delegate?.setSelectedBank(bank: bank)
    }
}
