//
//  ServicesCellView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 12/11/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import SnapKit

protocol ServicesCellViewDelegate: class {
    func serviceCategoryDidClicked(categoryId:String, categoryName:String, subcategoryId:String?, subcategoryName: String?)
}

class ServicesCellView : UIView {
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var servicename: UILabel!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var arrowIconImage: UILabel!
    @IBOutlet weak var servicesCollectionView: ServicesCollectionView!
    var isExpanded = true
    var allService = AllServices()
    weak var delegate: ServicesCellViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.serviceImageView.setRounded()
        
        self.serviceImageView.isUserInteractionEnabled = true
        self.serviceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCategoryHeaderPressed(_:))))
        
        self.servicename.isUserInteractionEnabled = true
        self.servicename.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHeaderPressed(_:))))
        
        self.arrowIconImage.isUserInteractionEnabled = true
        self.arrowIconImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onHeaderPressed(_:))))
        
        servicesCollectionView.delegate = self
    }
    
    func setContent(){
        
        arrowIconImage.transform = CGAffineTransform(rotationAngle: 0)
        serviceImageView.loadIGSImage(link: allService.iconUrl!)
        
        servicename.text = allService.categoryMenu
        
//        servicesCollectionView.commonInit()
        servicesCollectionView.setContent(service: allService.subcategories!)
        
        stackHeight.constant = servicesCollectionView.collectionView.collectionViewLayout.collectionViewContentSize.height
        
        layoutIfNeeded()
        self.isExpanded = !isExpanded
        if(isExpanded == false){
            collapse()
        }
    }
    
    func collapse(){
        arrowIconImage.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        servicesCollectionView.deleteAllData()
        stackHeight.constant = 0
        layoutIfNeeded()
        self.isExpanded = false
    }
    
    @objc func onHeaderPressed(_ sender: UITapGestureRecognizer){
        if self.isExpanded {
            collapse()
        } else {
            setContent()
        }
    }
    
    @objc func onCategoryHeaderPressed(_ sender: UITapGestureRecognizer){
        guard let categoryId = allService.categoryId, categoryId > 0, let categoryName = allService.categoryMenu else {
            return
        }
        delegate?.serviceCategoryDidClicked(categoryId: "\(categoryId)", categoryName: categoryName, subcategoryId: "",  subcategoryName: "" )
    }
    
}

extension ServicesCellView: MKCollectionViewDelegate {
    func collectionViewDidSelectedItemAtIndexPath(indexPath: IndexPath) {
//        if let serviceCategory = servicesCollectionView.getItem(indexPath: indexPath) as? SubCategories, let categoryId = serviceCategory.subcategoryId, let categoryName = serviceCategory.subcategoryName {
//            delegate?.serviceCategoryDidClicked(categoryId: "\(categoryId)", categoryName: categoryName ?? "")
//        }
    }
}

extension ServicesCellView : ServicesCollectionViewDelegate {
    func onCellClicked(subCategoryId: String, categoryName: String, subcategoryName: String) {
        guard let categoryId = allService.categoryId, categoryId > 0, let categoryName = allService.categoryMenu else {
            return
        }
        delegate?.serviceCategoryDidClicked(categoryId: "\(categoryId)", categoryName: categoryName, subcategoryId: subCategoryId, subcategoryName: subcategoryName)
    }

}
