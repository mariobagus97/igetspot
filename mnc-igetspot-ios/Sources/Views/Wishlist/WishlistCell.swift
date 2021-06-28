//
//  WishlistCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/13/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift

protocol WishlistCellDelegate: class {
    func wishlistDidClicked(wishlist:Wishlist)
    func wishlistButtonDidClicked(wishlist:Wishlist, cell:WishlistCell)
    func meetingButtonDidClicked(wishlist:Wishlist)
}

class WishlistCell : MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var panelContainerView: UIView!
    @IBOutlet weak var panelLeftView: UIView!
    @IBOutlet weak var panelCenterView: UIView!
    @IBOutlet weak var panelRightView: UIView!
    @IBOutlet weak var wishlistImageView: UIImageView!
    @IBOutlet weak var wishlistNameLabel: UILabel!
    @IBOutlet weak var wishlistPriceLabel: UILabel!
    @IBOutlet weak var wishlistBorderImage: UIView!
    @IBOutlet weak var wishlistMasterImage: UIImageView!
    @IBOutlet weak var buttonStackView: UIView!
    @IBOutlet weak var wishListButton: RNLoadingButton!
    @IBOutlet weak var meetingButton: UIButton!
    
    weak var delegate: WishlistCellDelegate?
    var wishlist: Wishlist?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wishlistBorderImage.makeItRounded(width: 1, borderColor: Colors.lightPurple.cgColor, cornerRadius: wishlistBorderImage.bounds.size.width/2)
        wishlistMasterImage.setRounded()
    }
    
    override func loadView() {
        super.loadView()
        
    }
    
    deinit {
        delegate = nil
    }
    
    func setContent(wishlist: Wishlist){
        self.wishlist = wishlist
        setWishlistButton(isWishlist: wishlist.isWishlist)
        wishlistPriceLabel.text = self.wishlist?.price?.currency
        wishlistNameLabel.text = self.wishlist?.packageName
        wishlistMasterImage.loadIGSImage(link: self.wishlist?.masterImageUrl ?? "", placeholderImage: R.image.userPlacaholder())
        if let wishlistImageUrls = self.wishlist?.packageImageArray, wishlistImageUrls.count > 0  {
            let imageUrl = wishlistImageUrls[0]
            wishlistImageView.loadIGSImage(link: imageUrl)
        }
    }
    
    func setLoadingWishlistButton(isLoading:Bool) {
        wishListButton.isLoading = isLoading
    }
    
    func setWishlistButton(isWishlist: Bool) {
        setLoadingWishlistButton(isLoading: false)
        let originalImage = R.image.iconLove()
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        wishListButton.setImage(tintedImage, for: .normal)
        if (isWishlist) {
            wishListButton.tintColor = Colors.scarlet
        } else {
            wishListButton.tintColor = Colors.gray
        }
        
    }
    
    // MARK: - Actions
    override func onSelected(){
        guard let wishlist = self.wishlist else {
            return
        }
        delegate?.wishlistDidClicked(wishlist: wishlist)
    }
    
    @IBAction func wishListButtonDidClicked() {
        guard let wishlist = self.wishlist else {
            return
        }
        delegate?.wishlistButtonDidClicked(wishlist: wishlist, cell: self)
    }
    
    @IBAction func meetingButtonDidClicked() {
        guard let wishlist = self.wishlist else {
            return
        }
        delegate?.meetingButtonDidClicked(wishlist: wishlist)
    }
    
}
