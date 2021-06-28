//
//  WalkthroughView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 19/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import FSPagerView

protocol WalkthroughViewDelegate: class {
    func skipButtonDidClicked()
    func walkthroughDidfinished()
}

class WalkthroughView: UIView {
    
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(UINib(resource: R.nib.walkthroughViewCell), forCellWithReuseIdentifier: R.reuseIdentifier.walkthroughViewCellIdentifier.identifier)
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .left
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.setFillColor(Colors.gray, for: .normal)
            self.pageControl.setFillColor(UIColor.black, for: .selected)
        }
    }
    
    
    let nextImage = R.image.nextButtton()
    weak var delegate: WalkthroughViewDelegate?
    var walkthroughArray: [Walkthrough]!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Function
    func setupWalkthrough(withWalkthroughs walkthroughs: [Walkthrough]?) {
        guard let walkthroughArray = walkthroughs, walkthroughArray.count > 0 else {
            return
        }
        self.walkthroughArray = walkthroughArray
        self.pageControl.numberOfPages = self.walkthroughArray.count
        pagerView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.handlePage(currentIndex: self.pagerView.currentIndex)
        }
        
    }
    
    // MARK: - Private Funtions
    private func handlePage(currentIndex:Int) {
        if (currentIndex + 1 == numberOfItems(in:self.pagerView)) {
            skipButton.alpha = 0.0
            nextButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 0.35, yStartPos: 0, yEndPos: 0)
            nextButton.setTitle(NSLocalizedString("Let’s go!", comment: ""), for: .normal)
            nextButton.setImage(nil, for: .normal)
        } else {
            skipButton.alpha = 1.0
            nextButton.removeGradient()
            nextButton.backgroundColor = UIColor.clear
            nextButton.setTitle(nil, for: .normal)
            nextButton.setImage(nextImage, for: .normal)
        }
        self.pageControl.currentPage = currentIndex
    }
    
    // MARK: - Actions
    @IBAction func skipButtonDidClicked() {
        delegate?.skipButtonDidClicked()
    }
    
    @IBAction func nextButtonDidClicked() {
        
        if (pagerView.currentIndex + 1 == numberOfItems(in:self.pagerView)) {
            delegate?.walkthroughDidfinished()
        } else {
            let nextIndex = pagerView.currentIndex + 1
            pagerView.scrollToItem(at: nextIndex, animated: true)
            handlePage(currentIndex: nextIndex)
        }
    }
}

// MARK:- FSPagerViewDataSource
extension WalkthroughView: FSPagerViewDataSource, FSPagerViewDelegate {
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.walkthroughArray.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.walkthroughViewCellIdentifier.identifier, at: index) as! WalkthroughViewCell
        let walkthrough = walkthroughArray[index]
        cell.setupCell(withWalkthrough: walkthrough)
        return cell
    }
    
    // MARK:- FSPagerViewDelegate
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.handlePage(currentIndex: targetIndex)
    }
}
