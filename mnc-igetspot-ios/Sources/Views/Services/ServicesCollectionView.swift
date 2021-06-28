//
//  ServicesCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/19/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit

protocol ServicesCollectionViewDelegate {
    func onCellClicked(subCategoryId: String, categoryName: String, subcategoryName: String)
}

class ServicesCollectionView: UIView{
    var servicesList = [SubCategories]()
    private var contentFlowLayout: UICollectionViewFlowLayout!
    var delegate : ServicesCollectionViewDelegate!
    var collectionView : UICollectionView!
    var thisColor : UIColor!
    
    override var intrinsicContentSize: CGSize {
        return self.contentFlowLayout.collectionViewContentSize
    }
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thisColor = self.getRandomColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.backgroundColor = .clear
    }
    
    func setupView(){
        contentFlowLayout = UICollectionViewFlowLayout()
        contentFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 10)
        contentFlowLayout?.itemSize = UICollectionViewFlowLayout.automaticSize
        contentFlowLayout?.estimatedItemSize = CGSize(width: 120, height: 50)
        contentFlowLayout?.scrollDirection = .horizontal
        
        let thisbounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(50))
        
        collectionView = IntrinsicSizeCollectionView(frame: thisbounds, collectionViewLayout: contentFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: R.nib.servicesCategoryCellView.name, bundle: nil), forCellWithReuseIdentifier: R.nib.servicesCategoryCellView.name)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(50)
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
        servicesList.removeAll()
    }
    
    func setContent(service : [SubCategories]){
        if (collectionView != nil && collectionView.isDescendant(of: self)){
            collectionView.removeFromSuperview()
        }
        setupView()
        self.servicesList = service
        let index : IndexSet = [0]
        self.collectionView.reloadSections(index)
        self.collectionView.snp.remakeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
            make.height.equalTo(collectionView.contentSize.height)
        }
    }
}

extension ServicesCollectionView : UICollectionViewDelegate{
    func collectionView(_ didSelectItemAtcollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.onCellClicked(subCategoryId: "\(self.servicesList[indexPath.row].subcategoryId ?? 0)", categoryName: self.servicesList[indexPath.row].subcategoryName ?? "", subcategoryName: self.servicesList[indexPath.row].subcategoryName ?? "")
    }
}


extension ServicesCollectionView : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.servicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.servicesCategoryCellView.name, for: indexPath) as! ServicesCategoryCellView
        if servicesList.indices.contains(indexPath.row){
            cell.setLabel(text: self.servicesList[indexPath.row].subcategoryName ?? "")
            cell.setColor(color: self.thisColor)
        }
        return cell
    }
}
