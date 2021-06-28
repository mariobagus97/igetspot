////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift

protocol MasterDetailImageHeaderViewDelegate:class {
    func wishlistButtonDidClicked()
}

class MasterDetailImageHeaderView: UIView {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var wishlistButton:RNLoadingButton!
    var profileImageUrl: String?
    weak var delegate: MasterDetailImageHeaderViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
        setupTapGestureImageProfile()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
        setupTapGestureImageProfile()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
        setupTapGestureImageProfile()
    }
    
    // MARK: - Actions
    @IBAction func wishlistButtonDidClicked() {
        delegate?.wishlistButtonDidClicked()
    }
    
    @objc func profileImageDidTapped() {
        guard let imageUrl = profileImageUrl else {
            return
        }
        let igsUrlString = IGSImageUrlHelper.getImageUrl(forPathUrl: imageUrl)
        IGSLightbox.show(imageSrcs: [igsUrlString])
    }

    // MARK: - Private Functions
    private func adjustLayout() {
        profileImageView.isSkeletonable = true
        profileImageView.setRounded()
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
    }
    
    private func setupTapGestureImageProfile() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageDidTapped))
        tap.cancelsTouchesInView = false
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Public Functions
    func setLoadingWishlistButton(isLoading:Bool) {
        wishlistButton.isLoading = isLoading
    }
    
    func setupWishlistButton(isWishlist:Bool) {
        wishlistButton.alpha = 1.0
        setLoadingWishlistButton(isLoading: false)
        if isWishlist {
            wishlistButton.setImage(R.image.wishlistSelected(), for: .normal)
        } else {
            wishlistButton.setImage(R.image.wishlistUnselected(), for: .normal)
        }
    }
    
    func hideWishlistButton() {
        wishlistButton.alpha = 0
    }
    
    func setImage(imageUrl:String) {
        profileImageUrl = imageUrl
        profileImageView.loadIGSImage(link: imageUrl, placeholderImage: R.image.userPlacaholder())
    }
    
    func setImageHeader(withUrlString urlString:String) {
        backgroundImageView.loadIGSImage(link: urlString, placeholderImage: R.image.parallaxHeader())
    }
    
}
