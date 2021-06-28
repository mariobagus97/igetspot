////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit


class MySpotMasterDetailPackageCollectionView: MKCollectionView {

    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 3
    var packageArray = [MySpotPackage]()
    
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
        if collectionView != nil {
            let sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 20)
            let minSpacing:CGFloat = 5.0
            let contentWidth: CGFloat = (((collectionView.bounds.width - (sectionInset.left + sectionInset.right) - (minSpacing * 2)) / numberOfColumns))
            let contentHeight: CGFloat = contentWidth
            let itemSize = CGSize(width: contentWidth, height: contentHeight)
            setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minSpacing, minimumInteritemSpacing: minSpacing, scrollDirection: .vertical)
        }
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.mySpotMasterDetailPackageCollectionCell.name,
             R.nib.mySpotAddPackageCollectionCell.name])
        
    }
    
    func removeContent(){
        packageArray.removeAll()
    }
    
    func setContent(packages: [MySpotPackage]){
        removeContent()
        let addPackage = MySpotPackage()
        addPackage.packageName = "Add Package"
        packageArray.append(contentsOf: packages)
        packageArray.append(addPackage)
        section.setItems(items: packageArray)
        appendSection(section: section)
        reloadData()
    }
    
    func getAddPackageCell(indexPath: IndexPath) -> MySpotAddPackageCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotAddPackageCollectionCell.name, indexPath: indexPath) as! MySpotAddPackageCollectionCell
        cell.setupCell(name: NSLocalizedString("Add Package", comment: ""), image: R.image.addIconWhite())
        return cell
    }
    
    func getNewCell(indexPath: IndexPath) -> MySpotMasterDetailPackageCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotMasterDetailPackageCollectionCell.name, indexPath: indexPath) as! MySpotMasterDetailPackageCollectionCell
        if packageArray.indices.contains(indexPath.row){
            cell.setupCell(package: packageArray[indexPath.row])
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        if (indexPath.row == packageArray.count - 1) {
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
