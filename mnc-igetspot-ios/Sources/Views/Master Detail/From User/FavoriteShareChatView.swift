////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import RNLoadingButton_Swift

protocol FavoriteShareChatViewDelegate: class {
    func favoriteButtonDidClicked()
    func shareButtonDidClicked()
    func chatButtonDidClicked()
    func moreButtonDidClicked()
}

class FavoriteShareChatView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var favoriteButton: RNLoadingButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: FavoriteShareChatViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Private Functions
    private func setupViews() {
        setupSkeletonView()
        setupFavoriteLoadingButton()
    }
    
    private func setupFavoriteLoadingButton() {
        favoriteButton.isLoading = false
        favoriteButton.hideTextWhenLoading = true
        favoriteButton.hideImageWhenLoading = true
    }
    
    private func setupSkeletonView() {
        contentView.isSkeletonable = true
        favoriteButton.isSkeletonable = true
        shareButton.isSkeletonable = true
        chatButton.isSkeletonable = true
        moreButton.isSkeletonable = true
    }
    
    // MARK: - Public Func
    func setLoadingFavoriteButton(isLoading:Bool) {
        favoriteButton.isLoading = isLoading
    }
    
    func setFavoriteButton(isFavorite:Bool) {
        setLoadingFavoriteButton(isLoading: false)
        if isFavorite {
            favoriteButton.setImage(R.image.favoriteSelected(), for: .normal)
        } else {
            favoriteButton.setImage(R.image.favoriteUnselected(), for: .normal)
        }
    }

    // MARK: - Actions
    @IBAction func favoriteButtonDidClicked() {
        delegate?.favoriteButtonDidClicked()
    }
    
    @IBAction func shareButtonDidClicked() {
        delegate?.shareButtonDidClicked()
    }
    
    @IBAction func chatButtonDidClicked() {
        delegate?.chatButtonDidClicked()
    }
    
    @IBAction func moreButtonDidClicked() {
        delegate?.moreButtonDidClicked()
    }
}
