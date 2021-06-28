//
//  SelectedImageCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/2/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SelectedImageCollectionViewDelegate {
    func onCellPressed(index: Int)
    func onDeleteImagePressed(index: Int)
    func onAddPressed()
    func updateParentHeight(height: CGFloat)
}

class SelectedImageCollectionView : MKCollectionView{
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 3
    var cellDelegate: SelectedImageCollectionViewDelegate?
    var type: Int!
    private var imageList = [UIImage]()
    private var index: Int!
    
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
        
        let sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let minSpacing:CGFloat = 10.0
        let contentWidth: CGFloat = (((collectionView.bounds.width - (sectionInset.left + sectionInset.right) - (minSpacing * 2)) / numberOfColumns))
        let contentHeight: CGFloat = contentWidth
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minSpacing, minimumInteritemSpacing: minSpacing, scrollDirection: .vertical)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.selectedImageCollectionViewCell.name,
                                                  R.nib.mySpotAddPackageCollectionCell.name])
    }
    
    func removeContent(){
        imageList.removeAll()
    }
    
    func setContent(imageList: [UIImage]?){
        removeContent()
        guard let imageArray = imageList else {
            return
        }
        self.imageList.append(contentsOf: imageArray)
        if (imageArray.count < 10){
            self.imageList.append(R.image.iconAddPhoto()!)
        }
        section.setItems(items:self.imageList)
        appendSection(section: section)
        reloadData()
    }
    
    func getAddPackageCell(indexPath: IndexPath) -> MySpotAddPackageCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotAddPackageCollectionCell.name, indexPath: indexPath) as! MySpotAddPackageCollectionCell
        cell.setupCell(name: NSLocalizedString("Add Image", comment: ""), image: R.image.addIconWhite())
        return cell
    }
    
    func getNewCell(indexPath: IndexPath) -> SelectedImageCollectionViewCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.selectedImageCollectionViewCell.name, indexPath: indexPath) as! SelectedImageCollectionViewCell
        cell.delegate = self
        cell.index = indexPath.row
        if imageList.indices.contains(indexPath.row){
            cell.setImage(image: self.imageList[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        if (indexPath.row == imageList.count - 1) {
            let cell = getAddPackageCell(indexPath: indexPath)
            cell.loadView()
            return cell
        } else {
            let cell = getNewCell(indexPath: indexPath)
            cell.loadView()
            return cell
        }
    }
}

extension SelectedImageCollectionView : SelectedImageCollectionViewCellDelegate {
    func didDeletePressed(index: Int) {
        self.cellDelegate?.onDeleteImagePressed(index: index)
    }
}
