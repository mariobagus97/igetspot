//
//  BrowseHelpCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/18/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class BrowseHelpCollectionView : UIView {
    
    private var contentFlowLayout: LeftAlignedCollectionViewFlowLayout!
    var collectionView : UICollectionView!
    var browseList = [String]()
    
    override var intrinsicContentSize: CGSize {
        return self.contentFlowLayout.collectionViewContentSize
    }
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.backgroundColor = .clear
        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func setupView(){
        contentFlowLayout = LeftAlignedCollectionViewFlowLayout()
        contentFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentFlowLayout?.itemSize = UICollectionViewFlowLayout.automaticSize
        contentFlowLayout?.estimatedItemSize = CGSize(width: 120, height: 60)
        contentFlowLayout?.scrollDirection = .vertical
        
        let thisbounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(60))
        
        collectionView = IntrinsicSizeCollectionView(frame: thisbounds, collectionViewLayout: contentFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: R.nib.servicesCategoryCellView.name, bundle: nil), forCellWithReuseIdentifier: R.nib.servicesCategoryCellView.name)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(60)
        }
    }
    
    func deleteAllData(){
        removeContent()
        let index : IndexSet = [0]
        self.collectionView.reloadSections(index)
        self.collectionView.snp.remakeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(collectionView.contentSize.height)
        }
    }
    
    func removeContent(){
        self.browseList.removeAll()
    }
    
    func setContent(list : [String]){
        if (collectionView != nil && collectionView.isDescendant(of: self)){
            collectionView.removeFromSuperview()
        }
        setupView()
        self.browseList = list
        let index : IndexSet = [0]
        self.collectionView.reloadSections(index)
        self.collectionView.snp.remakeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(collectionView.contentSize.height)
        }
    }

}

extension BrowseHelpCollectionView : UICollectionViewDelegate{
    func collectionView(_ didSelectItemAtcollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate.onCellPressed(search: String)
    }
}


extension BrowseHelpCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.browseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.servicesCategoryCellView.name, for: indexPath) as! ServicesCategoryCellView
        if browseList.indices.contains(indexPath.row){
            cell.updateHeight = true
            cell.setLabel(text: self.browseList[indexPath.row])
            cell.setGradient()
        }
        return cell
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
//                contentSize.width = contentSize.width + layoutAttribute.frame.size.width
//                contentSize.height = contentSize.width + layoutAttribute.frame.size.height
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
    
}
