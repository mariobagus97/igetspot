////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol PackageDetailPortofolioCollectionViewDelegate:class {
    func packagePortofolioDidClicked(imageUrl : String)
}

class PackageDetailPortofolioCollectionView: MKCollectionView {

    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var numberOfColumns: CGFloat = 3
    var portofolioImageUrls = [String]()
    weak var cellDelegate : PackageDetailPortofolioCollectionViewDelegate?
    
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
        registerCellIdentifiers(cellIdentifiers: [R.nib.packagePortofolioCollectionCell.name])
        
    }
    
    func removeContent(){
        portofolioImageUrls.removeAll()
    }
    
    func setContent(portofolioImageUrlArray: [String]){
        removeContent()
        portofolioImageUrls.append(contentsOf: portofolioImageUrlArray)
        section.setItems(items: portofolioImageUrls as [AnyObject])
        appendSection(section: section)
        reloadData()
    }
    
    func getNewCell(indexPath: IndexPath) -> PackagePortofolioCollectionCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.packagePortofolioCollectionCell.name, indexPath: indexPath) as! PackagePortofolioCollectionCell
        if portofolioImageUrls.indices.contains(indexPath.row){
            cell.setupCell(imageUrl: portofolioImageUrls[indexPath.row])
            cell.delegate = self
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

extension PackageDetailPortofolioCollectionView : PackagePortofolioCollectionCellDelegate {
    func packagePortofolioDidClicked(imageUrl: String) {
        self.cellDelegate?.packagePortofolioDidClicked(imageUrl: imageUrl)
    }
}
