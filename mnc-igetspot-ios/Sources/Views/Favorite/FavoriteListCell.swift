//
//  FavoriteListCell.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 27/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift

protocol FavoriteListCellDelegate: class {
    func favoriteButtonDidClicked(cell:FavoriteListCell, favorite: Favorite)
    func chatButtonDidClicked(favorite: Favorite)
    func favoriteCellDidClicked(favorite: Favorite)
}

class FavoriteListCell: MKTableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerImageView: UIView!
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favoriteButton: RNLoadingButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var containerAddressView: UIView!
    weak var delegate: FavoriteListCellDelegate?
    var favorite: Favorite?
    
    // MARK:- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        containerImageView.makeItRounded(width: 1, borderColor: Colors.lightPurple.cgColor, cornerRadius: containerImageView.bounds.size.width/2)
        masterImageView.setRounded()
    }
    
    deinit {
        delegate = nil
    }

//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//
//        if highlighted {
//            self.containerView.backgroundColor = Colors.veryLightPink
//        } else {
//            self.containerView.backgroundColor = .white
//        }
//
//        setNeedsLayout()
//        layoutIfNeeded()
//    }
    
    override func onSelected() {
        guard let favorite = self.favorite else {
            return
        }
        delegate?.favoriteCellDidClicked(favorite: favorite)
    }
    
    // MARK:- Actions
    @IBAction func favoriteButtonDidClicked() {
        guard let favorite = self.favorite else {
            return
        }
        delegate?.favoriteButtonDidClicked(cell: self, favorite: favorite)
    }
    
    @IBAction func chatButtonDidClicked() {
        guard let favorite = self.favorite else {
            return
        }
        delegate?.chatButtonDidClicked(favorite: favorite)
    }
    
    // MARK: - Private Functions
    
    
    
    // MARK:- Public Functions
    func setContent(withFavorite favorite:Favorite) {
        self.favorite = favorite
        masterImageView.loadIGSImage(link: favorite.masterImageUrl ?? "", placeholderImage: R.image.userPlacaholder())
        masterNameLabel.text = favorite.masterName
        
        if let address = favorite.address, address.isEmpty == false {
            containerAddressView.alpha = 1.0
            addressLabel.text = favorite.address
        } else {
            addressLabel.text = ""
            containerAddressView.alpha = 0.0
        }
        setupFavoriteButton(isFavorite: favorite.isFavorite)
    }
    
    func setLoadingFavoriteButton(isLoading:Bool) {
        favoriteButton.isLoading = isLoading
    }
    
    func setupFavoriteButton(isFavorite:Bool) {
        setLoadingFavoriteButton(isLoading: false)
        if (isFavorite) {
            favoriteButton.setImage(R.image.favoriteSelected(), for: .normal)
        } else {
            favoriteButton.setImage(R.image.favoriteUnselected(), for: .normal)
        }
    }
    
    func setBackground(_ highlighted: Bool = false){
        
        if highlighted {
            self.containerView.backgroundColor = Colors.veryLightPink
        } else {
            self.containerView.backgroundColor = .white
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    
}
