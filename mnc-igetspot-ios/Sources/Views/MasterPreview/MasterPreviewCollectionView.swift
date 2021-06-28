//
//  MasterPreviewCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/24/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MasterPreviewCollectionViewDelegate {
    func hideThisKeyboard()
}

class MasterPreviewCollectionView : MKCollectionView{
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 2
    var masterList = [MasterPreview]()
    var celldelegate: MasterPreviewCollectionViewDelegate!
    
    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
        self.backgroundColor = .clear
        self.collectionView.backgroundView?.backgroundColor = .clear
        self.collectionView.isScrollEnabled = true
        self.collectionView.bounces = true
        addSection()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionViewInset = UIEdgeInsets(top: 21, left: 22, bottom: 20, right: 27)
        let minimumSpacing: CGFloat = 5
        let minimumLineSpacing: CGFloat = 15
        collectionView.contentInset = collectionViewInset
        let contentWidth: CGFloat = ((collectionView.bounds.width - collectionViewInset.left - collectionViewInset.right) / numberOfColumns) - minimumSpacing
        let contentHeight: CGFloat = contentWidth
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        print("layoutSubviews itemSize :\(itemSize )")
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minimumLineSpacing, minimumInteritemSpacing: minimumSpacing, scrollDirection: .vertical)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        celldelegate?.hideThisKeyboard()
    }
    
    func addSection(){
        appendSection(section: section)
    }
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.masterPreviewCell.name])
        
    }
    
    func removeContent(){
       masterList.removeAll()
    }
    
    func setContent(masters: [MasterPreview]){
        masterList.append(contentsOf: masters)
        UIView.performWithoutAnimation {
            section.setItems(items: masterList)
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }
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
}
