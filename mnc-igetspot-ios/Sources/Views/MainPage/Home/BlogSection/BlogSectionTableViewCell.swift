//
//  BlogSectionTableViewCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/9/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

class BlogSectionTableViewCell : MKTableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var slides:[BlogSectionSlider] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        
        
        scrollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        
        bringSubviewToFront(pageControl)
    }
    
    
    func createSlides() -> [BlogSectionSlider] {
        
        let slide1:BlogSectionSlider = Bundle.main.loadNibNamed("BlogSectionSlider", owner: self, options: nil)?.first as! BlogSectionSlider
        slide1.imageView.image = UIImage(named: "ic_onboarding_1")
        
        let slide2:BlogSectionSlider = Bundle.main.loadNibNamed("BlogSectionSlider", owner: self, options: nil)?.first as! BlogSectionSlider
        slide2.imageView.image = UIImage(named: "ic_onboarding_2")
        
        let slide3:BlogSectionSlider = Bundle.main.loadNibNamed("BlogSectionSlider", owner: self, options: nil)?.first as! BlogSectionSlider
        slide3.imageView.image = UIImage(named: "ic_onboarding_3")
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [BlogSectionSlider]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(slides.count), height: self.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    /*
     * default function called when view is scolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/self.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//        
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//        
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//        
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//        
//        
//        /*
//         * below code changes the background color of view on paging the scrollview
//         */
//        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
//        
//        
//        /*
//         * below code scales the imageview on paging the scrollview
//         */
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//        
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//            
//            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//            
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//            
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//            
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
//    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        /*
         *
         */
        setupSlideScrollView(slides: slides)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / self.frame.width)
        
        
        // on each dot, call the transform of scale 1 to restore the scale of previously selected dot
        
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        // transform the scale of the current subview dot, adjust the scale as required, but bigger the scale value, the downward the dots goes from its centre.
        // You can adjust the centre anchor of the selected dot to keep it in place approximately.
        
        let centreBeforeScaling = self.pageControl.subviews[self.pageControl.currentPage].center
        
        self.pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 5, y: 5)
        
        
        // Reposition using autolayout
        
        self.pageControl.subviews[self.pageControl.currentPage].translatesAutoresizingMaskIntoConstraints = false
        
        self.pageControl.subviews[self.pageControl.currentPage].centerYAnchor.constraint(equalTo: self.pageControl.subviews[0].centerYAnchor , constant: 0)
        
        self.pageControl.subviews[self.pageControl.currentPage].centerXAnchor.constraint(equalTo: self.pageControl.subviews[0].centerXAnchor , constant: 0)
        
        
        //    self.pageControl.subviews[self.pageControl.currentPage].layer.anchorPoint = centreBeforeScaling
        
    }
    
}
