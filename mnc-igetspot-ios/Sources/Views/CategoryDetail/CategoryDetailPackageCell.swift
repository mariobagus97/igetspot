//
//  CategoryDetailPackageCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/30/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Cosmos

protocol CategoryDetailPackageCellDelegate: class {
    func packageCellDidSelect(package:Package)
    func packageSearchCellDidSelect(package:MasterSearch)
}

class CategoryDetailPackageCell : MKTableViewCell{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var masterNameLabel : UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var packagerateCosmos: CosmosView!
    @IBOutlet weak var reviewByLabel: UILabel!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagelocationLabel: UILabel!
    @IBOutlet weak var containerLocationView: UIView!
    weak var delegate: CategoryDetailPackageCellDelegate?
    var package: Package?
    var searchPackage: MasterSearch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        packageImageView.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: 8)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.containerView.backgroundColor = Colors.veryLightPink
        } else {
            self.containerView.backgroundColor = .clear
        }
    }
    
    override func onSelected() {
        if let pkg = self.package {
            delegate?.packageCellDidSelect(package: pkg)
        } else if let packageSearch = self.searchPackage {
            delegate?.packageSearchCellDidSelect(package: packageSearch)
        }
    }
    
    
    func setContent(package : Package) {
        self.package = package
        if let imageArray = package.packageImageArray, imageArray.count > 0 {
            let packageImageUrl = imageArray[0]
            packageImageView.loadIGSImage(link: packageImageUrl, placeholderImage: R.image.blankImage())
        }
        
        masterNameLabel.text = "\(package.masterName ?? "")"
        packagePriceLabel.text = package.price?.currency
        
        if let rate = package.rate, let rateDouble = Double(rate) {
            packagerateCosmos.rating = rateDouble
        } else {
            packagerateCosmos.rating = 0.0
        }
        
        reviewByLabel.text = "\(package.totalReview ?? "0") Reviews"
        packageNameLabel.text = package.packageName
        if let city = package.city, city.isEmpty == false {
            var formatCity = city.replacingOccurrences(of: "Kota", with: "")
            formatCity = formatCity.trimmingCharacters(in: .whitespacesAndNewlines)
            containerLocationView.alpha = 1.0
            packagelocationLabel.text = formatCity
        } else {
            packagelocationLabel.text = ""
            containerLocationView.alpha = 0.0
        }
    }
    
    func setSearchContent(package: MasterSearch){
        self.searchPackage = package
        if let image = searchPackage?.packageImageUrl {
            packageImageView.loadIGSImage(link: image, placeholderImage: R.image.blankImage())
        }
        
        masterNameLabel.text = "\(searchPackage?.masterName ?? "")"
        packagePriceLabel.text = searchPackage?.packagePrice?.currency
        
        if let rate = package.masterAvgRating {
            packagerateCosmos.rating = rate
        } else {
            packagerateCosmos.rating = 0.0
        }
        
        reviewByLabel.text = "\(searchPackage?.masterTotalReview ?? 0) Reviews"
        packageNameLabel.text = package.packageName
        if let address = package.masterAddress {
            containerLocationView.alpha = 1.0
            packagelocationLabel.text = address
        } else {
            packagelocationLabel.text = ""
            containerLocationView.alpha = 0.0
        }
    }
}
