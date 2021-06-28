//
//  PopularSearchCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 3/6/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

protocol PopularSearchCellDelegate : class {
    func onClearAllPressed()
    func onCellPressed(text: String)
    func refreshTable()
}

class PopularSearchCell : MKTableViewCell {
    
    @IBOutlet weak var clearAllLabel: UILabel!
    @IBOutlet weak var popularCollectionView: PopularSearchCollectionView!
    weak var delegate: PopularSearchCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        popularCollectionView.commonInit()
        popularCollectionView.cellDelegate = self
        
        addGesture()
    }
    
    func setContent(content : [String]){
        popularCollectionView.setContent(list: content)
        popularCollectionView.collectionView.collectionViewLayout.invalidateLayout()
        setNeedsLayout()
        layoutIfNeeded()
        delegate.refreshTable()
    }
    
    func addGesture(){
        clearAllLabel.isUserInteractionEnabled = true
        clearAllLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClearPressed(_:))))
    }
    
    @objc func onClearPressed(_ sender: UITapGestureRecognizer){
        popularCollectionView.deleteAllData()
        popularCollectionView.collectionView.collectionViewLayout.invalidateLayout()
        popularCollectionView.frame.size.height = 0
        setNeedsLayout()
        layoutIfNeeded()
        delegate.refreshTable()
    }
}

extension PopularSearchCell : PopularSearchCollectionViewDelegate{
    func onCellPressed(search: String) {
        self.delegate.onCellPressed(text: search)
    }
}

class IntrinsicSizeCollectionView: TPKeyboardAvoidingCollectionView {
    // MARK: - lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let intrinsicContentSize = self.contentSize
            return intrinsicContentSize
        }
    }
    
    // MARK: - setup
    func setup() {
        self.isScrollEnabled = false
        self.bounces = false
    }
}
