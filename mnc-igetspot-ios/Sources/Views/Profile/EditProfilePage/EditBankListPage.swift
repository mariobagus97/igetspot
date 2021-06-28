//
//  EditBankListPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 11/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditBankListPageDelegate {
    func didHidePressed()
    func setBank(bank: Bank)
}

class EditBankListPage: UIView {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var bankListTable: UITableView!
    
    var delegate : EditBankListPageDelegate!
    var bankList = [Bank]()
    var selectedBank : Bank!
    var bankId = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bankListTable.delegate = self
        bankListTable.dataSource = self
        bankListTable.estimatedRowHeight = 80
        bankListTable.rowHeight = 80
        bankListTable.register(UINib(nibName: "RadioButtonDoubleLabelCell", bundle: nil), forCellReuseIdentifier: "RadioButtonDoubleLabelCell")
    }
    
    func setContent(bankList: [Bank], bankId: String){
        self.bankList = bankList
        self.bankId = bankId
        
        bankListTable.reloadData()
        tableHeight.constant = bankListTable.contentSize.height
        self.setNeedsLayout()
        layoutIfNeeded()
    }
    
    @IBAction func onHidepressed(_ sender: Any) {
        delegate?.didHidePressed()
    }
}

extension EditBankListPage : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = self.bankList[indexPath.row]
        selectedBank = bank
        self.bankListTable.reloadData()
        delegate?.setBank(bank: selectedBank)
    }
}

extension EditBankListPage : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonDoubleLabelCell", for: indexPath) as! RadioButtonDoubleLabelCell
        let bankOption = self.bankList[indexPath.row]
        var isSelected = false
        if (bankOption.id == selectedBank?.id || bankOption.id == self.bankId) {
            isSelected = true
        }
        
        cell.setContent(firstString: bankOption.bankName, secondString: bankOption.bankDesc, isSelected: isSelected)
        
        return cell
    }
}
