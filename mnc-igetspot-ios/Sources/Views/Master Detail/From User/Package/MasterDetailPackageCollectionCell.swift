//
//  MasterDetailPackageCollectionCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/15/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Alamofire

protocol MasterDetailPackageCollectionCellDelegate {
    func onCellPressed(packageDetailList: PackageDetailList)
}

class MasterDetailPackageCollectionCell : MKCollectionViewCell{
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    
    var cellDelegate : MasterDetailPackageCollectionCellDelegate?
    var packageDetailList = PackageDetailList()
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupContainerViewTapable()
    }
    
    
    override func loadView() {
        super.loadView()
        
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.4)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.5)
        self.containerView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.packageImageView.makeItRounded(borderColor: UIColor.clear.cgColor, cornerRadius: 10.0)
        self.containerView.backgroundColor = Colors.gray
    }
    
    // MARK: - Public Functions
    func setupCell(packageDetailList : PackageDetailList){
        
        self.packageDetailList = packageDetailList
        
        packageNameLabel.text = packageDetailList.packageName
        packagePriceLabel.text = packageDetailList.price?.currency
        
        guard let imageUrls = packageDetailList.imageUrls, imageUrls.count > 0 else {
            return
        }
        
        let imageUrlString = imageUrls[0]
        self.packageImageView.loadIGSImage(link: imageUrlString)
    }

    // MARK: - Private Functions
    private func setupContainerViewTapable() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onCellPressed(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Tap Gesture
    @objc func onCellPressed(_ sender: UITapGestureRecognizer) {
        print("onCellPressed...")
        self.cellDelegate?.onCellPressed(packageDetailList: self.packageDetailList)
    }
}


