//
//  PopularResultCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/6/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit


protocol PopularResultCellDelegate : class {
    func onFilterPressed()
    func onResultPressed(package: MasterSearch)
}

class PopularResultCell : MKTableViewCell {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var resultTableView: ResultSearchTableView!
    weak var delegate: PopularResultCellDelegate!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewHeight.constant = 30
        resultTableView.cellDelegate = self
        addGesture()
    }
    
    func addGesture(){
        filterView.isUserInteractionEnabled = true
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFilterViewPressed(_:))))
    }
    
    func setResultContent(package : [MasterSearch]){
        print("total rows total items \(package.count)")
        resultTableView.setResultContent(list: package)
        resultTableView.contentView.tableView.reloadData()
        resultTableView.contentView.tableView.setNeedsLayout()
        resultTableView.contentView.tableView.layoutIfNeeded()
        tableViewHeight.constant = resultTableView.contentView.tableView.contentSize.height
        print("total rows height \(resultTableView.contentView.tableView.contentSize.height)")
        print(" _ ")
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func onFilterViewPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.onFilterPressed()
    }
}

extension PopularResultCell : ResultSearchTableViewDelegate {
    func onCellPressed(package: MasterSearch) {
        self.delegate?.onResultPressed(package: package)
    }
}

