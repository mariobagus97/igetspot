//
//  CategoryDetailFilterTab.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol CategoryDetailFilterTabDelegate: class {
    func onSortPressed()
    func onFilterPressed()
    func onSharePressed()
}

class CategoryDetailFilterTab : UIView {
    
    weak var delegate : CategoryDetailFilterTabDelegate!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupGestureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupGestureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestureView()
    }
    
    func setupGestureView() {
        sortView.isUserInteractionEnabled = true
        sortView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onSortViewPressed(_:))))
        
        filterView.isUserInteractionEnabled = true
        filterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onFilterViewPressed(_:))))
        
        shareView.isUserInteractionEnabled = true
        shareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(onShareViewPressed(_:))))
        
    }

    
    @objc func onSortViewPressed(_ sender: UITapGestureRecognizer) {
        self.delegate?.onSortPressed()
    }
    
    @objc func onFilterViewPressed(_ sender: UITapGestureRecognizer) {
        self.delegate?.onFilterPressed()
    }
    
    @objc func onShareViewPressed(_ sender: UITapGestureRecognizer) {
        self.delegate?.onSharePressed()
    }
    
}
