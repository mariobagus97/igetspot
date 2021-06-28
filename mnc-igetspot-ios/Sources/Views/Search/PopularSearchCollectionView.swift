//
//  PopularSearchCollectionView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit


protocol PopularSearchCollectionViewDelegate {
    func onCellPressed(search: String)
}

class PopularSearchCollectionView: UIView {
    
    var cellDelegate : PopularSearchCollectionViewDelegate!
    private var searchList = [String]()
    private var contentFlowLayout: LeftAlignedCollectionViewFlowLayout!
    var collectionView : UICollectionView!
    
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
        if (UIDevice.current.screenType == .iPhones_5_5s_5c_SE) {
            contentFlowLayout?.estimatedItemSize = CGSize(width: 120, height: 30)
        } else {
            contentFlowLayout?.estimatedItemSize = CGSize(width: 120, height: 0)
        }
        contentFlowLayout?.scrollDirection = .vertical
        
        let thisbounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(30))
        
        collectionView = IntrinsicSizeCollectionView(frame: thisbounds, collectionViewLayout: contentFlowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: R.nib.servicesCategoryCellView.name, bundle: nil), forCellWithReuseIdentifier: R.nib.servicesCategoryCellView.name)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints{ make in
            make.left.right.top.bottom.equalTo(self)
        }
    }
 
    
    func deleteAllData(){
        removeContent()
        let index : IndexSet = [0]
        self.collectionView.reloadSections(index)
        collectionView.reloadData()
        collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        self.collectionView.frame.size.height = 0
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func removeContent(){
        searchList.removeAll()
    }
    
    func setContent(list : [String]){
        if (collectionView != nil && collectionView.isDescendant(of: self)){
            collectionView.removeFromSuperview()
        }
        setupView()
        self.searchList = list
        let index : IndexSet = [0]
        collectionView.reloadSections(index)
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }

}

extension PopularSearchCollectionView : UICollectionViewDelegate{
    func collectionView(_ didSelectItemAtcollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellDelegate.onCellPressed(search: self.searchList[indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let isLastItem = indexPath.item == (collectionView.numberOfItems(inSection: indexPath.section) - 1)
//        guard isLastItem else {
//            return
//        }
//
//        DispatchQueue.main.async {
//            let inset = (cell.frame.maxX - collectionView.contentSize.width) + 10 // 10 is the right padding I want for my horizontal scroll
//            collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: inset)
//        }
//    }
}


extension PopularSearchCollectionView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.servicesCategoryCellView.name, for: indexPath) as! ServicesCategoryCellView
        if searchList.indices.contains(indexPath.row){
            cell.setLabel(text: self.searchList[indexPath.row])
            cell.setGradient()
        }
        return cell
    }
}

