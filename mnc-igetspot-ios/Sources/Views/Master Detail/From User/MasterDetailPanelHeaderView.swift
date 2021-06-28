////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MasterDetailPanelHeaderViewDelegate: class {
    func favoriteButtonDidClicked()
    func shareButtonDidClicked()
    func chatButtonDidClicked()
    func moreButtonDidClicked()
}

class MasterDetailPanelHeaderView: UIView {

    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterAddressLabel: UILabel!
    @IBOutlet weak var masterRatingLabel: UILabel!
    @IBOutlet weak var titleRatingLabel: UILabel!
    @IBOutlet weak var pinLocationImageView: UIImageView!
    @IBOutlet weak var containerNameView: UIView!
    @IBOutlet weak var containerAddressView: UIView!
    @IBOutlet weak var containerRatingView: UIView!
    @IBOutlet weak var favoriteShareChatView: FavoriteShareChatView!
    weak var delegate: MasterDetailPanelHeaderViewDelegate?
    var masterDetail: MasterDetail?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }

    // MARK: - Private Functions
    private func adjustLayout() {
        masterNameLabel.isSkeletonable = true
        masterAddressLabel.isSkeletonable = true
        masterRatingLabel.isSkeletonable = true
        titleRatingLabel.isSkeletonable = true
        pinLocationImageView.isSkeletonable = true
        favoriteShareChatView.isSkeletonable = true
        favoriteShareChatView.delegate = self
    }
    
    // MARK: - Public Functions
    func setContent(masterDetail:MasterDetail?){
        guard let master = masterDetail else {
            return
        }
        self.masterDetail = master
        if let city = masterDetail?.city, city.isEmpty == false {
            var formatCity = city.replacingOccurrences(of: "Kota", with: "")
            formatCity = formatCity.trimmingCharacters(in: .whitespacesAndNewlines)
            containerAddressView.alpha = 1.0
            masterAddressLabel.text = formatCity
        } else {
            masterAddressLabel.text = ""
            containerAddressView.alpha = 0.0
        }
        
        var ratingMaster:Double = 0
        if let rating = master.rating, rating > 0 {
            ratingMaster = rating
            masterRatingLabel.text = String(format: "%.1f", ratingMaster)
        } else {
            masterRatingLabel.text = "-"
        }
        
        setFavorite(isFavorite: master.isFavorite)
    }
    
    func setFavorite(isFavorite:Bool) {
        favoriteShareChatView.setFavoriteButton(isFavorite: isFavorite)
    }
    
    func hideFavorite() {
        favoriteShareChatView.favoriteButton.alpha = 0.0
    }
    
    func loadingFavoriteButton(isLoading:Bool) {
        favoriteShareChatView.setLoadingFavoriteButton(isLoading: isLoading)
    }
    
    func setMasterName(_ masterName:String) {
        masterNameLabel.text = masterName
    }
    
    func showloadingView() {
        containerNameView.showAnimatedGradientSkeleton()
        containerRatingView.showAnimatedGradientSkeleton()
        favoriteShareChatView.showAnimatedGradientSkeleton()
    }
    
    func hideLoadingView() {
        containerNameView.hideSkeleton()
        containerRatingView.hideSkeleton()
        favoriteShareChatView.hideSkeleton()
    }
}

extension MasterDetailPanelHeaderView: FavoriteShareChatViewDelegate {
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
