////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MySpotMasterDetailHeaderView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var profileImageUrl: String?
    
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
    @objc func profileImageDidTapped() {
        guard let imageUrl = profileImageUrl else {
            return
        }
        let igsUrlString = IGSImageUrlHelper.getImageUrl(forPathUrl: imageUrl)
        IGSLightbox.show(imageSrcs: [igsUrlString])
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        overlayView.applyGradient(colors: [UIColor.clear, UIColor.black.withAlphaComponent(0.3)], xStartPos: 0, xEndPos: 0, yStartPos: 0, yEndPos: 0.1)
        
        profileImageView.isSkeletonable = true
        profileImageView.setRounded()
        backgroundImageView.backgroundColor = getRandomColor()
    }
    
    private func setupTapGestureImageProfile() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageDidTapped))
        tap.cancelsTouchesInView = false
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    // MARK: - Public Functions
    func setContent(mySpotMasterDetail:MySpotMasterDetail) {
        setImage(imageUrl: mySpotMasterDetail.masterAvatarImageUrl ?? "")
        setImageHeader(withUrlString: mySpotMasterDetail.masterBackgroundImageUrl ?? "")
        masterNameLabel.text = mySpotMasterDetail.masterName
        addressLabel.text = mySpotMasterDetail.address
        
    }
    func setImage(imageUrl:String) {
        profileImageUrl = imageUrl
        profileImageView.loadIGSImage(link: imageUrl, placeholderImage: R.image.userPlacaholder())
    }
    
    func setImageHeader(withUrlString urlString:String) {
        backgroundImageView.loadIGSImage(link: urlString, placeholderImage: R.image.parallaxHeader())
    }
    
}
