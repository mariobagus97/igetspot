//
//  ResultSearchTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol ResultSearchTableViewDelegate {
    func onCellPressed(package: MasterSearch)
}

class ResultSearchTableView: UIView, MKTableViewDelegate {
    
    var cellDelegate : ResultSearchTableViewDelegate!
    var section : MKTableViewSection!
    var contentView: MKTableView!
//    var packageCell : CategoryDetailPackageCell!
    
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
        self.contentView.tableView.contentInset = UIEdgeInsets.zero
        self.addSubview(contentView)
        
        let topOffset:CGFloat = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? 60 : 80
        
        contentView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(self)
        }
    }
    
    // MARK: - MKTableViewDelegate
    func createRows() {
        createResultCell()
    }
    
    func createSections() {
        section = MKTableViewSection()
        contentView.appendSection(section)
        
        contentView.reloadData()
    }
    
    func registerNibs() {
        contentView.registeredCellIdentifiers.append(contentsOf: [
            R.nib.categoryDetailPackageCell.name
            ])
    }
    
    func setResultContent(list: [MasterSearch]){
//        var resultlist = list
//        resultlist.append(MasterSearch())
        print("total rows table heree \(list.count)")
        for item in list {
            let packageCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.categoryDetailPackageCell.name) as! CategoryDetailPackageCell
            packageCell.delegate = self
            packageCell.setSearchContent(package: item)
            section.appendRow(cell: packageCell)
        }
    }
    
    private func createResultCell(){
    }
    
}

extension ResultSearchTableView : CategoryDetailPackageCellDelegate {
    
    func packageCellDidSelect(package:Package) {
        
    }
    
    func packageSearchCellDidSelect(package:MasterSearch){
        self.cellDelegate?.onCellPressed(package: package)
    }
}
