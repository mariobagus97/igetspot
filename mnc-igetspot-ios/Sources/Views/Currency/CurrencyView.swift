//
//  CurrencyView.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 10/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CurrencyViewDelegate {
    func onCurrencySelected(currencyList: [CurrencyObject], selected: Int)
    func didHidePressed()
}

class CurrencyView: UIView {
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyTableView: UITableView!
    
    var currencyList = [CurrencyObject]()
    var selectedCurrency: CurrencyObject?
    var delegate : CurrencyViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        currencyTableView.estimatedRowHeight = 70
        currencyTableView.rowHeight = 70
        currencyTableView.isScrollEnabled = false
        currencyTableView.register(UINib(nibName: "RadioButtonDoubleLabelCell", bundle: nil), forCellReuseIdentifier: "RadioButtonDoubleLabelCell")
    }
    
    func setList(){
        
        var currency = (key: String, value: String, isSelected: Bool).self

//        currencyList.append((key: "IDR", value:"Rupiah", isSelected: true))
//        currencyList.append((key: "USD", value:"US Dollar", isSelected: false))
//        currencyList.append((key: "MYR", value:"Malaysian ringgit", isSelected: false))
//        currencyList.append((key: "SGD", value:"Singaporean Dollar", isSelected: false))
    

    }
    
    func setContent(currencyList: [CurrencyObject]){
        self.currencyList = currencyList
        currencyTableView.reloadData()
        tableHeight.constant = currencyTableView.contentSize.height
        self.setNeedsLayout()
        layoutIfNeeded()
    }
    
    @IBAction func onHidePressed(_ sender: Any) {
        delegate?.didHidePressed()
    }
    
}

extension CurrencyView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencyList[indexPath.row]
        selectedCurrency = currency
        self.currencyTableView.reloadData()
        delegate?.onCurrencySelected(currencyList: currencyList, selected: indexPath.row)
    }
}

extension CurrencyView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonDoubleLabelCell", for: indexPath) as! RadioButtonDoubleLabelCell
        let currencyOption = self.currencyList[indexPath.row]
        
        cell.setContent(firstString: currencyOption.currencyCode, secondString: currencyOption.currencyName, isSelected: currencyOption.isChosen)
        return cell
    }
}
