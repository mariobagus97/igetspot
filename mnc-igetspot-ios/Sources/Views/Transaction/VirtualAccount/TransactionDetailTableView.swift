//
//  TransactionDetailTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/27/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol TransactionDetailTableViewDelegate {
    func updateHeight(height: CGFloat)
}

class TransactionDetailTableView : UIView, MKTableViewDelegate {
    
    var section = MKTableViewSection()
    var contentView: MKTableView!
    var transactionDetailCell : TransactionDetailCell!
    var delegate : TransactionDetailTableViewDelegate!
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: - Public Functions
    func setupView() {
        contentView = MKTableView(frame: .zero)
        contentView.registerDelegate(delegate: self)
        contentView.tableView.isScrollEnabled = false
        self.addSubview(contentView)
        
        let topOffset:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 60 : 80
        
        contentView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
    }
    
    func createSections() {
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.transactionDetailCell.name
            ])
    }
    
    func setContent(list: [TransactionDetailVA]){
        contentView.appendSection(section)
        for item in list {
            createTransactionCell()
            transactionDetailCell.setContent(detail: item)
        }
        
        self.contentView.tableView.reloadData()
        self.contentView.tableView.setNeedsLayout()
        contentView.tableView.layoutIfNeeded()
    }
    
    private func createTransactionCell(){
        transactionDetailCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.transactionDetailCell.name) as? TransactionDetailCell
        section.appendRow(cell: transactionDetailCell)
        //        packageCell.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        super.updateConstraints()
        self.delegate?.updateHeight(height: self.contentView.tableView.contentSize.height)
    }

}
