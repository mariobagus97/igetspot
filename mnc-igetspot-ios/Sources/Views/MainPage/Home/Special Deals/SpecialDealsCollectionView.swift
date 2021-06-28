//
//  SpecialDealsCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/18/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit


class SpecialDealsCollectionView : MKCollectionView {
    
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    
    var numberOfColumns: CGFloat = 1.25
    
    var dealList = [Deals]()
    
    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 10)
        let contentWidth: CGFloat = (((collectionView.bounds.width - (sectionInset.left + sectionInset.right)) / numberOfColumns))
        let contentHeight: CGFloat = (collectionView.bounds.height)
        
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: 20, minimumInteritemSpacing: 20, scrollDirection: .horizontal)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.specialDealsCollectionViewCell.name])
        
    }
    
    func removeContent(){
        dealList.removeAll()
    }
    
    func setContent(deals: [Deals]){
        removeContent()
        dealList = deals
        section.setItems(items: dealList)
        appendSection(section: section)
        reloadData()
    }
    
    func getNewCell(indexPath: IndexPath) -> SpecialDealsCollectionViewCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.specialDealsCollectionViewCell.name, indexPath: indexPath) as! SpecialDealsCollectionViewCell
        if dealList.indices.contains(indexPath.row){
//            cell.masterCategory = masterCategories[indexPath.row]
            cell.setupCell(deal: dealList[indexPath.row])
            //            cell.delegate = self
            cell.loadView()
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
