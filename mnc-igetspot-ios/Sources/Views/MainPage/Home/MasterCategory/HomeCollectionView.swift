//
//  HomeCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MasterCategoryCellDelegate {
    func isPressed(item : MasterCategory)
}

class HomeCollectionView: MKCollectionView {
    
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    
    var numberOfColumns: CGFloat = 2
    
    var cellDelegate: MasterCategoryCellDelegate!
    
    private var masterCategories = [MasterCategory]()
    
    private var index: Int!

    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
        
        self.backgroundColor = .clear
        self.collectionView.backgroundView?.backgroundColor = .clear

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let contentWidth: CGFloat = (((collectionView.bounds.width ) / numberOfColumns) - 5)
        let contentHeight: CGFloat = contentWidth / 2.116
        
        let collectionViewInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        collectionView.contentInset = collectionViewInset
        
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumSpacing: 0, scrollDirection: .vertical)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.masterCategoryCollectionViewCell.name])
        
    }
    
    func removeContent(){
        masterCategories.removeAll()
    }
    
    func setContent(masterCategories: [MasterCategory]){
        removeContent()
        self.masterCategories = masterCategories
        section.setItems(items: self.masterCategories)
        appendSection(section: section)
        reloadData()
        let index : IndexSet = [0]
        collectionView.reloadSections(index)
    }
    
    func getNewCell(indexPath: IndexPath) -> MasterCategoryCollectionViewCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.masterCategoryCollectionViewCell.name, indexPath: indexPath) as! MasterCategoryCollectionViewCell
        if masterCategories.indices.contains(indexPath.row){
            cell.masterCategory = masterCategories[indexPath.row]
            cell.setupCell()
            cell.delegate = self
            cell.loadView()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        let cell = getNewCell(indexPath: indexPath)
        cell.loadView()
        self.index = indexPath.row
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
    
    
}

extension HomeCollectionView: MasterCategoryCollectionCellDelegate {
    func isPressed(item: MasterCategory) {
        self.cellDelegate?.isPressed(item: item)
    }

}
