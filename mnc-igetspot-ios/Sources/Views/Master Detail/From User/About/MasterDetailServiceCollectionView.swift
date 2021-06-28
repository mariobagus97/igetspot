////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MasterDetailServiceCollectionView: MKCollectionView {

    private var section: MKCollectionViewSection = MKCollectionViewSection()
    var servicesArray = [ServiceCategory]()
    private var dataItems = [String]()
    private var contentFlowLayout: UICollectionViewFlowLayout!
    
    override var intrinsicContentSize: CGSize {
        return self.contentFlowLayout.collectionViewContentSize
    }
    
    override func commonInitConfigureCollectionView() {
        super.commonInitConfigureCollectionView()
        self.backgroundColor = .clear
        collectionView.backgroundView?.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        contentFlowLayout = UICollectionViewFlowLayout()
        contentFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 41, bottom: 0, right: 20)
        contentFlowLayout?.itemSize = UICollectionViewFlowLayout.automaticSize
        contentFlowLayout?.estimatedItemSize = CGSize(width: 120, height: 50)
        contentFlowLayout?.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = contentFlowLayout!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func registerNibs() {
        super.registerNibs()
        registerCellIdentifiers(cellIdentifiers: [R.nib.dynamicSizeCell.name])
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        let cell = getNewCell(indexPath: indexPath)
        cell.loadView()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return servicesArray.count
    }
    
    func removeContent(){
        servicesArray.removeAll()
    }
    
    func setContent(services : [ServiceCategory]) {
        removeContent()
        self.servicesArray = services
        section.setItems(items: services)
        appendSection(section: section)
        reloadData()
        layoutIfNeeded()
    }
    
    func deleteAllData(){
        removeContent()
        reloadData()
        refreshLayout()
    }
    
    func deleteAll(section: Int){
        
        var indexPath = [IndexPath]()
        if (servicesArray.count > 0){
            let length = servicesArray.count - 1
            for i in 0...length {
                indexPath.append(IndexPath(item: i, section: 0))
            }
            collectionView.deleteItems(at: indexPath)
        }
    }
    
    func getNewCell(indexPath: IndexPath) -> DynamicSizeCell {
        let cell = dequeueReusableCellWithIdentifier(nibName: R.nib.dynamicSizeCell.name, indexPath: indexPath) as! DynamicSizeCell
        if servicesArray.indices.contains(indexPath.row) {
            cell.setupCell(withServiceCategory: self.servicesArray[indexPath.row])
        }
        return cell
    }
}
