//
//  MasterDetailPackageTableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MasterDetailPackageTableViewCellDelegate {
    func onCellPressed(packageDetailList : PackageDetailList)
}

class MasterDetailPackageTableViewCell: MKTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var masterDetailCollectionView: MasterDetailPackageCollectionView!
    var cellDelegate : MasterDetailPackageTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        masterDetailCollectionView.commonInit()
        masterDetailCollectionView.delegate = self
        self.masterDetailCollectionView.snp.removeConstraints()
        self.masterDetailCollectionView.snp.makeConstraints { make in
            make.height.equalTo(masterDetailCollectionView.getViewContentSize().height).priority(999)
        }
        masterDetailCollectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        masterDetailCollectionView.layoutIfNeeded()
    }
    
    func setContent(packageDetailLists: [PackageDetailList]){
        masterDetailCollectionView.setContent(packageDetailLists: packageDetailLists)
        layoutSubviews()
    }
    
    func removeContent(){
        masterDetailCollectionView.removeContent()
    }
    
}

extension MasterDetailPackageTableViewCell : MasterDetailPackageCollectionViewDelegate {
    func onCellPressed(packageDetailList: PackageDetailList) {
        self.cellDelegate?.onCellPressed(packageDetailList: packageDetailList)
    }
}

extension MasterDetailPackageTableViewCell: MKCollectionViewDelegate {
    
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
        if let packageDetail = masterDetailCollectionView.getItem(indexPath: indexPath) as? PackageDetailList {
            self.cellDelegate?.onCellPressed(packageDetailList: packageDetail)
        }
    }
}
