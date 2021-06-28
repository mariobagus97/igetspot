//
//  SearchView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/5/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    func onClearAllPressed()
    func onFilterPressed()
    func onResultPressed(package: MasterSearch)
    func onSearchPressed(search: String)
}

class SearchView: UIView {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var popularCollectionView: PopularSearchCollectionView!
    @IBOutlet weak var resultTableView: ResultSearchTableView!
    @IBOutlet weak var clearAllLabel: UILabel!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var resultTableHeight: NSLayoutConstraint!
    var delegate : SearchViewDelegate!
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDelegate()
        addGesture()
        
    }
    
    func setDelegate(){
//        popularCollectionView.commonInit()
        popularCollectionView.cellDelegate = self
        resultTableView.cellDelegate = self
    }
    
    func addGesture(){
        filterView.isUserInteractionEnabled = true
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFilterViewPressed(_:))))
    }
    
    @objc func onFilterViewPressed(_ sender: UITapGestureRecognizer){
        self.delegate?.onFilterPressed()
    }
    
    func setPopularContent(content : [String]){
        popularCollectionView.setContent(list: content)
//        collectionViewHeight.constant = popularCollectionView.collectionView
    }
    
    func setResultContent(package : [MasterSearch]){
        resultTableView.setResultContent(list: package)
    }
    
}

extension SearchView : PopularSearchCollectionViewDelegate{
    func onCellPressed(search: String) {
        self.delegate.onSearchPressed(search: search)
    }
}

extension SearchView : ResultSearchTableViewDelegate {
    func onCellPressed(package: MasterSearch) {
        self.delegate?.onResultPressed(package: package)
    }
}
