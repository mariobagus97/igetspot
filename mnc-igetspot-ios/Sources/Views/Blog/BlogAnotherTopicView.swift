////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import FSPagerView

protocol BlogAnotherTopicViewDelegate: class {
    func anotherTopicDidClicked(withBlog blog:Whatson, blogArray:[Whatson]?)
    func seeAllBlogDidClicked()
}

class BlogAnotherTopicView: UIView {

    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(UINib(resource: R.nib.blogAnotherTopicCell), forCellWithReuseIdentifier: R.reuseIdentifier.blogAnotherTopicCellIdentifier.identifier)
            self.pagerView.interitemSpacing = 15
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            self.pageControl.setFillColor(Colors.gray, for: .selected)
            self.pageControl.setFillColor(Colors.lightBlueGrey, for: .normal)
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seeAllButton: UIButton!
    var whatsOnArray: [Whatson]?
    weak var delegate: BlogAnotherTopicViewDelegate?

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    // MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    @IBAction func seeAllButtonDidClicked() {
        delegate?.seeAllBlogDidClicked()
    }
    
    // MARK: - Public Functions
    func setContent(withBlogs blogs:[Whatson]?) {
        self.layoutIfNeeded()
        whatsOnArray = blogs
        pageControl.numberOfPages = blogs?.count ?? 0
        let newScaleWidth = 0.5+CGFloat(0.6)*0.5 // [0.5 - 1.0]
        let newScaleHeight = 0.5+CGFloat(1)*0.5 // [0.5 - 1.0]
        let newSize = self.pagerView.frame.size.applying(CGAffineTransform(scaleX: newScaleWidth, y: newScaleHeight))
        self.pagerView.itemSize = newSize
        
        pagerView.reloadData()
    }
}

// MARK: - FSPagerViewDelegate FSPagerViewDataSource
extension BlogAnotherTopicView: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        guard let whatsOnArray = self.whatsOnArray else {
            return 0
        }
        return whatsOnArray.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.blogAnotherTopicCellIdentifier.identifier, at: index) as! BlogAnotherTopicCell
        guard let whatsOnArray = self.whatsOnArray else {
            return cell
        }
        let whatsOn = whatsOnArray[index]
        cell.setContent(blog: whatsOn)
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
        delegate?.anotherTopicDidClicked(withBlog: whatsOn, blogArray: self.whatsOnArray)
    }
}