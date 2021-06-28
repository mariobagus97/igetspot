////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotPackagePortofolioCollectionViewDelegate:class {
    func deletePortofolioDidClicked(packagePortofolio:MySpotPackageImage)
}

class MySpotPackagePortofolioCollectionView: MKCollectionView {
    
    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 3
    var packagePortofolios = [MySpotPackageImage]()
    weak var cellDelegate : MySpotPackagePortofolioCollectionViewDelegate?
    
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
        let minSpacing:CGFloat = 10.0
        let contentWidth: CGFloat = (((collectionView.bounds.width - (sectionInset.left + sectionInset.right) - (minSpacing * 2)) / numberOfColumns))
        let contentHeight: CGFloat = contentWidth
        let itemSize = CGSize(width: contentWidth, height: contentHeight)
        setLayout(itemSize: itemSize, sectionInset: sectionInset, minimumLineSpacing: minSpacing, minimumInteritemSpacing: minSpacing, scrollDirection: .vertical)
    }
    
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.mySpotPackagePortofolioCollectionCell.name,
             R.nib.mySpotAddPackageCollectionCell.name])
    }
    
    func removeContent(){
        packagePortofolios.removeAll()
    }
    
    func setContent(packagePortofolios: [MySpotPackageImage]){
        removeContent()
        self.packagePortofolios.append(contentsOf: packagePortofolios)
        let addPortofolio = MySpotPackageImage()
        addPortofolio.imageId = "Add Portofolio"
        self.packagePortofolios.append(addPortofolio)
        section.setItems(items:self.packagePortofolios)
        appendSection(section: section)
        reloadData()
    }
    
    func getAddPackageCell(indexPath: IndexPath) -> MySpotAddPackageCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotAddPackageCollectionCell.name, indexPath: indexPath) as! MySpotAddPackageCollectionCell
        cell.setupCell(name: NSLocalizedString("Add Portofolio", comment: ""), image: R.image.addIconWhite())
        return cell
    }
    
    func getNewCell(indexPath: IndexPath) -> MySpotPackagePortofolioCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotPackagePortofolioCollectionCell.name, indexPath: indexPath) as! MySpotPackagePortofolioCollectionCell
        if packagePortofolios.indices.contains(indexPath.row){
            cell.setupCell(packageImage: packagePortofolios[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        if (indexPath.row == packagePortofolios.count - 1) {
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

extension MySpotPackagePortofolioCollectionView : MySpotPackagePortofolioCollectionCellDelegate {
    func deleteButtonDidClicked(packageImage:MySpotPackageImage, cell:MySpotPackagePortofolioCollectionCell) {
        cellDelegate?.deletePortofolioDidClicked(packagePortofolio: packageImage)
    }
    
}
