//
//  YourTransactionDetail.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/27/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit


class YourTransactionDetail : MKTableViewCell {
    
    @IBOutlet weak var detailTableView: TransactionDetailTableView!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailTableView.delegate = self
        detailTableView.makeItRounded(width: 1, borderColor: UIColor.rgb(red: 242, green: 242, blue: 242).cgColor, cornerRadius: 5)
    }
    
    func setContent(transactionList: [TransactionDetailVA]){
        
        detailTableView.setContent(list: transactionList)
       
    }
}

extension YourTransactionDetail : TransactionDetailTableViewDelegate {
    func updateHeight(height: CGFloat) {
        detailTableView.invalidateIntrinsicContentSize()
        detailTableView.layoutIfNeeded()
        
        let temp = tableHeight.constant
        
        print("table height 1 \(tableHeight.constant)")
        
        if (height > tableHeight.constant){
            tableHeight.constant = height
        }
        
        print("table height 2 \(detailTableView.contentView.tableView.contentSize.height)")
        
        print("table height 3 \(tableHeight.constant)")
        print("table height        ")
        
        detailTableView.setNeedsLayout()
        detailTableView.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
