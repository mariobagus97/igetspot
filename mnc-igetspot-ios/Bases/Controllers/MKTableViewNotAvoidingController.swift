//
//  MKTableViewNotAvoidingController.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import SnapKit

class MKTableViewNotAvoidingController: MKViewController, MKTableViewNotAvoidingDelegate {
    
    var contentView: MKTableViewNotAvoiding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = MKTableViewNotAvoiding(frame: .zero)
        contentView.registerDelegate(delegate: self)
        
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view)
        }
        setupTableViewStyles()
        
    }
    
    func setupTableViewStyles() {
        self.view.backgroundColor = .white
    }
    
    func createRows() {}
    
    func createSections() {
        contentView.removeAllSection()
        contentView.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let threshold: CGFloat = 100.0
        var lastOffset: CGPoint = .zero
        
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        //        if (maximumOffset - contentOffset <= threshold) && loadingSection.cells.count > 0  {
        //            touchBottom.onNext(1)
        //        }
    }
    
    func registerNibs() {}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let mkCell = cell as? MKTableViewCell {
            mkCell.loadView()
        }
    }
    
}
