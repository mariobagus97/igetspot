//
//  BankListTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 01/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol BankListTableViewDelegate {
    func onCellPressed(bank: Bank)
}

class BankListTableView: UIView {
    
    var delegate : BankListTableViewDelegate!
    var tableView = UITableView()
    var bankList = [Bank]()
    var selectedBank : Bank?
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
    }
    
    // MARK: - Private Functions
    private func setupTableView() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.bottom.right.left.equalTo(self)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = 70
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: "RadioButtonAndTitleCell", bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.radioButtonAndTitleCell.identifier)
    }
    
    func setContent(list : [Bank]){
        self.bankList =  list
        tableView.reloadData()
        self.layoutIfNeeded()
        
    }
    
}

// MARK: - UITableViewDataSource
extension BankListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.radioButtonAndTitleCell.identifier, for: indexPath) as! RadioButtonAndTitleCell
        let bankOption = self.bankList[indexPath.row]
        var isSelected = false
        if bankOption.bankCode == selectedBank?.bankCode {
            isSelected = true
        }
        
        cell.setContent(withTitle: bankOption.bankName, isSelected: isSelected)
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension BankListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = bankList[indexPath.row]
        selectedBank = bank
        self.tableView.reloadData()
        delegate?.onCellPressed(bank: bank)
    }
}
