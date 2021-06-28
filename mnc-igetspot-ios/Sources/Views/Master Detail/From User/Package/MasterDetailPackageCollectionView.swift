//
//  MasterDetailPackageCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MasterDetailPackageCollectionViewDelegate {
    func onCellPressed(packageDetailList : PackageDetailList)
}

class MasterDetailPackageCollectionView: MKCollectionView {
    
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 3
    var packageDetailList = [PackageDetailList]()
    var cellDelegate : MasterDetailPackageCollectionViewDelegate?
    
    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
        self.backgroundColor = .clear
        self.collectionView.backgroundView?.backgroundColor = .clear
        self.collectionView.isScrollEnabled = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
        let minSpacing:CGFloat = 5.0
        let contentWidth: CGFloat = (((UIScreen.main.bounds.width - (sectionInset.left + sectionInset.right) - (minSpacing * 2)) / numberOfColumns))
        let contentHeight: CGFloat = contentWidth
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minSpacing, minimumInteritemSpacing: minSpacing, scrollDirection: .vertical)
    }
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.masterDetailPackageCollectionCell.name])
    }
    
    func removeContent(){
        packageDetailList.removeAll()
    }
    
    func setContent(packageDetailLists: [PackageDetailList]){
        removeContent()
        packageDetailList.append(contentsOf: packageDetailLists)
        section.setItems(items: packageDetailList)
        appendSection(section: section)
        reloadData()
    }
    
    func getNewCell(indexPath: IndexPath) -> MasterDetailPackageCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.masterDetailPackageCollectionCell.name, indexPath: indexPath) as! MasterDetailPackageCollectionCell
        if packageDetailList.indices.contains(indexPath.row){
            cell.setupCell(packageDetailList: packageDetailList[indexPath.row])
            cell.cellDelegate = self
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        let cell = getNewCell(indexPath: indexPath)
        cell.loadView()
        return cell
    }
    
}

extension MasterDetailPackageCollectionView : MasterDetailPackageCollectionCellDelegate {
    func onCellPressed(packageDetailList: PackageDetailList) {
        self.cellDelegate?.onCellPressed(packageDetailList: packageDetailList)
    }
}
