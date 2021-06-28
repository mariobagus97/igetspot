//
//  HomeContentCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 20/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FSPagerView
import SkeletonView

protocol HomeContentCellDelegate:class {
    func blogDidClicked(withWhatsOn whatsOn:Whatson, blogArray: [Whatson]?)
    func categoryDidClicked(withCategory homeCategory:HomeCategory)
}

class HomeContentCell: MKTableViewCell {
    
    var whatsOnArray: [Whatson]?
    var homeCategories: [HomeCategory]?
    weak var delegate:HomeContentCellDelegate?

    @IBOutlet weak var blogtitle: UILabel!
    @IBOutlet weak var blogwriter: UILabel!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionViewConstraint: NSLayoutConstraint!
    let inset: CGFloat = 20
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 20
    let cellsPerRow = 2
    var isLoading = false
    var slidingInterval:CGFloat = 5.0
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPagerView()
        setupPageControl()
        setupCollectionView()
    }
    
    // MARK: - Private Functions
    private func setupPagerView() {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(UINib(resource: R.nib.homeBlogCell), forCellWithReuseIdentifier: R.reuseIdentifier.homeBlogCellIdentifier.identifier)
        pagerView.isInfinite = true
        pagerView.removesInfiniteLoopForSingleItem = true
        pagerView.automaticSlidingInterval = slidingInterval
    }
    
    private func setupPageControl() {
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let dotCurrentPage = UIImage(color: Colors.purple, size: CGSize(width: 4, height: 4))?.rounded(with: UIColor.white, width: 1)
        pageControl.setImage(dotCurrentPage, for: .selected)
        let dotNormalPage = UIImage(color: UIColor.white, size: CGSize(width: 2, height: 2))?.rounded(with: UIColor.white, width: 1)
        pageControl.setImage(dotNormalPage, for: .normal)
        pageControl.itemSpacing = 7
        
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(resource: R.nib.homeCategoryViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.homeCategoryViewCellIdentifier.identifier)
    }
    
    // MARK: - Publics Function
    
    func showLoadingView() {
        isLoading = true
        self.updateCollectionViewHeight()
    }
    
    func hideLoadingView() {
        isLoading = false
    }
    
    func updateCollectionViewHeight() {
        self.collectionView.reloadData()
        heightCollectionViewConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        self.layoutIfNeeded()
    }
    
    func setContent(categoryArray:[HomeCategory]) {
        setContentCategoryServices(categories: categoryArray)
    }
    
    func setContent(whatsOnArray:[Whatson]) {
        self.whatsOnArray = whatsOnArray
        self.pageControl.numberOfPages = whatsOnArray.count
        self.pagerView.reloadData()
    }
    
    func setContentCategoryServices(categories: [HomeCategory]){
        self.homeCategories = categories
        self.updateCollectionViewHeight()
    }
    
    func automaticScrollingPager(isSliding:Bool) {
        self.pagerView.automaticSlidingInterval = isSliding ? slidingInterval : 0.0
    }
    
}


// MARK: - UICollectionViewDataSource
extension HomeContentCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalItems = 0
        if isLoading {
            totalItems = 8
        }
        if let cateogories = self.homeCategories {
            totalItems = cateogories.count
        }
        return totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.homeCategoryViewCellIdentifier.identifier, for: indexPath) as! HomeCategoryViewCell
        guard let cateogories = self.homeCategories, cateogories.count > 0 else {
            if isLoading {
                cell.showAnimatedGradientSkeleton()
            }
            return cell
        }
        let homeCategories = cateogories[indexPath.item]
        cell.setContent(homeCategories: homeCategories)
        cell.hideSkeleton()
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension HomeContentCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let categories = self.homeCategories else {
            return
        }
        let homeCategory = categories[indexPath.item]
        delegate?.categoryDidClicked(withCategory: homeCategory)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeContentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var marginsAndInsets:CGFloat = 0
        if #available(iOS 11.0, *) {
            marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        } else {
            marginsAndInsets = inset * 2 + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        }
        let itemWidth = ((UIScreen.main.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: 70)
    }
}


// MARK: - FSPagerViewDelegate FSPagerViewDataSource
extension HomeContentCell: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let whatsOnArray = self.whatsOnArray else {
            return 0
        }
        return whatsOnArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.homeBlogCellIdentifier.identifier, at: index) as! HomeBlogCell
        guard let whatsOnArray = self.whatsOnArray else {
            return cell
        }
        let whatsOn = whatsOnArray[index]
        cell.setContent(withWhatsOn: whatsOn)
        blogtitle.text = whatsOn.title
        blogwriter.text = whatsOn.author
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        guard let whatsOnArray = self.whatsOnArray else {
            return
        }
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let whatsOn = whatsOnArray[index]
        delegate?.blogDidClicked(withWhatsOn: whatsOn, blogArray: whatsOnArray)
    }
}

