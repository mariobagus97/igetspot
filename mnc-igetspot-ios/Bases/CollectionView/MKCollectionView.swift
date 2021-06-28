//
//  MKCollectionView.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol MKCollectionViewDelegate {
    
    @objc optional func collectionViewDidCommonInit()
    @objc optional func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath)
    @objc optional func collectionViewDidAppearAtLastIndexPath(indexPath: IndexPath)
    @objc optional func collectionViewDidAppearAtIndexPath(indexPath: IndexPath)
    @objc optional func collectionViewDidScrollToBottom()
    
}

class MKCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: MKCollectionViewDelegate?
    var collectionView: IntrinsicSizeCollectionView!
    private var numberOfColumn: NSInteger = 0
    private var itemViewSize: CGSize = CGSize.zero
    private var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    private var minimumSpacing: CGFloat = 10
    private var sections: [MKCollectionViewSection] = [MKCollectionViewSection]()
    
    var requestedPages: [NSInteger] = [NSInteger]()
    var renderedPages: [NSInteger] = [NSInteger]()
    
//    override var intrinsicContentSize: CGSize {
//        get {
//            var intrinsicContentSize = temp
//            let temp = CGSize(width: 100, height: 100)
//            if self.collectionView != nil {
//                let intrinsicContentSize = self.collectionView.contentSize
//            } else {
//                 let intrinsicContentSize = temp
//            }
//            return intrinsicContentSize
//        }
//    }
    
    func registerNibs() {}
    func scrollDidToBottom(status: Bool) {}
    
    func commonInitConfigureCollectionView() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func commonInit() {
        commonInitCreateCollectionView()
        commonInitConfigureCollectionView()
//        delegate?.collectionViewDidCommonInit?()
//        if let delegate = self.delegate {
//            if let method = delegate.collectionViewDidCommonInit {
//                method()
//            }
//        }
    }
    
    private func commonInitCreateCollectionView() {
        if collectionView == nil {
            collectionView = IntrinsicSizeCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.delegate = self
            collectionView.dataSource = self
            setupCollectionViewStyles()
            registerNibs()
            setLayout(itemSize: CGSize(width: collectionView.frame.width, height: collectionView.frame.width), sectionInset: UIEdgeInsets.zero, minimumLineSpacing: 10, minimumInteritemSpacing: 10, scrollDirection: .vertical)
            addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.left.right.top.bottom.equalTo(self)
            }
        }
    }
    
    func setupCollectionViewStyles(){
        collectionView.backgroundColor = .clear
    }
    
    func removeAllSections() {
        sections.removeAll()
    }
    
    func addRequestedPage(pageNumber: NSInteger) {
        if !hasRequestedPage(pageNumber: pageNumber) {
            requestedPages.append(pageNumber)
        }
    }
    
    func hasRequestedPage(pageNumber: NSInteger) -> Bool {
        if requestedPages.index(of: pageNumber) == nil {
            return false
        }
        return true
    }
    
    func addRenderedPage(pageNumber: NSInteger) {
        if !hasRenderedPage(pageNumber: pageNumber) {
            renderedPages.append(pageNumber)
        }
    }
    
    func hasRenderedPage(pageNumber: NSInteger) -> Bool {
        if renderedPages.index(of: pageNumber) == nil {
            return false
        }
        return true
    }
    
    func setLayout(itemSize: CGSize, sectionInset: UIEdgeInsets, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection) {
        itemViewSize = itemSize
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.itemSize = itemSize
        layout.sectionInset = sectionInset
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        collectionView.collectionViewLayout = layout
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func showFooterActivityIndicator(show: Bool) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            var width = self.collectionView.frame.size.width
            var height: CGFloat = 55 //LoadingView.HEIGHT
            if layout.scrollDirection == .horizontal {
                width = layout.itemSize.width
                height = layout.itemSize.height
            }
            if !show {
                height = 0
            }
            layout.footerReferenceSize = CGSize(width: width, height: height)
        }
    }
    
    func setNumberOfColumn(numberOfColumn: NSInteger, multiplierHeight: CGFloat, sectionInset: UIEdgeInsets, minimumSpacing: CGFloat) {
        self.numberOfColumn = numberOfColumn
        self.sectionInset = sectionInset
        self.minimumSpacing = minimumSpacing
        itemViewSize.width = SizeHelper.getWidthGrid(containerWidth: SizeHelper.WINDOW_WIDTH, horizontalPadding: sectionInset.left, columnSpacing: minimumSpacing, columnCount: self.numberOfColumn)
        itemViewSize.height = itemViewSize.width * multiplierHeight
        setLayout(itemSize: itemViewSize, sectionInset: sectionInset, minimumLineSpacing: minimumSpacing, minimumInteritemSpacing: minimumSpacing, scrollDirection: .vertical)
    }
    
    func getContentViewHeightAtSectionIndex(index: NSInteger) -> CGFloat {
        if numberOfColumn > 0 && itemViewSize != CGSize.zero && hasSectionAtIndex(index: index) {
            let totalRow = ceil(Float(sections[index].numberOfItems()) / Float(numberOfColumn))
            let totalContentViewHeight = CGFloat(totalRow) * itemViewSize.height
            let totalVerticalPadding = sectionInset.top + sectionInset.bottom
            let totalContentSpacing = (CGFloat(totalRow) - 1) * minimumSpacing
            return totalContentViewHeight + totalVerticalPadding + totalContentSpacing
        }
        return 0
    }
    
    func registerCellIdentifiers(cellIdentifiers: [String]) {
        for cellIdentifier in cellIdentifiers {
            let nib = UINib(nibName: cellIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        }
    }
    
    func hasSectionAtIndex(index: NSInteger) -> Bool {
        return index < sections.count
    }
    
    func hasIndexPath(indexPath: IndexPath) -> Bool {
        return hasSectionAtIndex(index: indexPath.section) && sections[indexPath.section].hasItemAtIndex(index: indexPath.row)
    }
    
    func getItem(indexPath: IndexPath) -> AnyObject? {
        if hasIndexPath(indexPath: indexPath) {
            return sections[indexPath.section].getItemAtIndex(index: indexPath.row)
        }
        return nil
    }
    
    func appendSection(section: MKCollectionViewSection) {
        sections.append(section)
    }
    
    func appendItemIntoSection(items: [AnyObject], section: MKCollectionViewSection) {
        section.appendItem(item: items as AnyObject)
    }
    
    func dequeueReusableCellWithIdentifier(nibName: String, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: nibName, for: indexPath)
    }
    
    func isLastIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section == (sections.count - 1) && indexPath.row == (sections[indexPath.section].numberOfItems() - 1)
    }
    
    func getViewContentSize() -> CGSize {
        return collectionView.collectionViewLayout.collectionViewContentSize
    }
    
    func reloadData() {
        if collectionView != nil {
            collectionView.reloadData()
            collectionView.setNeedsLayout()
            collectionView.layoutIfNeeded()
        }
    }
    
    func refreshLayout() {
        if collectionView != nil {
            collectionView.collectionViewLayout.invalidateLayout()
            commonInit()
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if hasSectionAtIndex(index: section) {
            return sections[section].numberOfItems()
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewDidAppearAtIndexPath(indexPath: indexPath)
        return UICollectionViewCell()
    }
    
    func collectionView(_ didSelectItemAtcollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            if let method = delegate.collectionViewDidSelectedItemAtIndexPath {
                method(indexPath)
            }
        }
    }
    
    func collectionViewDidAppearAtIndexPath(indexPath: IndexPath) {
        if let delegate = self.delegate {
            if let method = delegate.collectionViewDidAppearAtIndexPath {
                method(indexPath)
            }
        }
        if isLastIndexPath(indexPath: indexPath) {
            if let delegate = self.delegate {
                if let method = delegate.collectionViewDidAppearAtLastIndexPath {
                    method(indexPath)
                }
            }
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 0) {
            if let delegate = self.delegate {
                if let method = delegate.collectionViewDidScrollToBottom {
                    method()
                }
            }
        }
    }
    
}
