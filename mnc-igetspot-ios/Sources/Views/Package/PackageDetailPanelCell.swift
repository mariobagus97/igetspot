////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Cosmos

protocol PackageDetailPanelCellDelegate: class {
    func favoriteButtonDidClicked()
    func shareButtonDidClicked()
    func chatButtonDidClicked()
    func moreButtonDidClicked()
}


class PackageDetailPanelCell: MKTableViewCell {
    
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterAddressLabel: UILabel!
    @IBOutlet weak var containerAddressView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteShareChatView: FavoriteShareChatView!
    weak var delegate: PackageDetailPanelCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        favoriteShareChatView.delegate = self
    }
    
    func setContent(packageDetail:PackageDetail) {
        masterNameLabel.text = packageDetail.masterName
        if let address = packageDetail.address, address.isEmpty == false {
            containerAddressView.alpha = 1.0
            masterAddressLabel.text = address
        } else {
            masterAddressLabel.text = "Asda"
            containerAddressView.alpha = 0.0
        }
        
        if let rating = packageDetail.rating, rating.isEmpty == false {
            ratingLabel.text = rating
        } else {
            ratingLabel.text = "-"
        }
    }
    
    func hideFavorite() {
        favoriteShareChatView.favoriteButton.alpha = 0.0
    }
    
    func setFavorite(isFavorite:Bool) {
        favoriteShareChatView.setFavoriteButton(isFavorite: isFavorite)
    }
    
    func loadingFavoriteButton(isLoading:Bool) {
        favoriteShareChatView.setLoadingFavoriteButton(isLoading: isLoading)
    }
    
}


extension PackageDetailPanelCell: FavoriteShareChatViewDelegate {
    func favoriteButtonDidClicked() {
        delegate?.favoriteButtonDidClicked()
    }
    
    func shareButtonDidClicked() {
        delegate?.shareButtonDidClicked()
    }
    
    func chatButtonDidClicked() {
        delegate?.chatButtonDidClicked()
    }
    
    func moreButtonDidClicked() {
        delegate?.moreButtonDidClicked()
    }
}
