//
//  MasterOfTheWeekCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/5/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class MasterOfTheWeekCollectionView: MKCollectionView {
    
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    
    static let numberOfColumns: CGFloat = 2.5
    var masterList = [MasterPreview]()
    let collectionViewInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    let minimumSpacing: CGFloat = 8
    
    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
        
        self.backgroundColor = .clear
        self.collectionView.backgroundView?.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isScrollEnabled = true
        self.collectionView.bounces = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.contentInset = collectionViewInset
        let cellSize = getContentHeight(basedScreenType: UIDevice.current.screenType)
        let itemSize = CGSize(width: cellSize, height: cellSize)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minimumSpacing, minimumInteritemSpacing: 0, scrollDirection: .horizontal)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.masterPreviewCell.name])
    }
    
    func removeContent(){
        masterList.removeAll()
    }
    
    func setContent(master: [MasterPreview]){
        removeContent()
        masterList = master
        section.setItems(items: masterList)
        appendSection(section: section)
        reloadData()
    }
    
    func getNewCell(indexPath: IndexPath) -> MasterPreviewCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.masterPreviewCell.name, indexPath: indexPath) as! MasterPreviewCell
        if masterList.indices.contains(indexPath.row){
            cell.setupCell(master: masterList[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        let cell = getNewCell(indexPath: indexPath)
        cell.loadView()
        return cell
    }
    
    func getContentHeight(basedScreenType screenType:UIDevice.ScreenType) -> CGFloat {
        var contenHeight:CGFloat = 125
        switch UIDevice.current.screenType {
        case .iPhones_5_5s_5c_SE:
            contenHeight -= 20
        case .iPhones_6_6s_7_8:
            contenHeight += 0
        case .iPhones_6Plus_6sPlus_7Plus_8Plus, .iPhone_XR:
            contenHeight += 15
        case .iPhones_X_XS:
            contenHeight += 5
        case .iPhone_XSMax:
            contenHeight += 20
        default:
            break
        }
        
        return contenHeight
    }
    
}


