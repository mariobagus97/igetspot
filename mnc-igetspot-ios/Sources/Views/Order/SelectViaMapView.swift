////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SelectViaMapViewDelegate:class {
    func setEventLocationButtonDidClicked(place:GooglePlace)
    func closeMapButtonDidClicked()
}

class SelectViaMapView: UIView {

    @IBOutlet weak var setEventLocationButton: UIButton!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var heightButtonConstraint: NSLayoutConstraint!
    weak var delegate: SelectViaMapViewDelegate?
    var selectedPlace:GooglePlace?
    
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
    
    @IBAction func closeButtonDidClicked() {
        delegate?.closeMapButtonDidClicked()
    }
    
    @IBAction func selectButtonDidClicked() {
        guard let place = self.selectedPlace else {
            return
        }
        delegate?.setEventLocationButtonDidClicked(place: place)
    }
    
    func adjustLayout() {
        setEventLocationButton.makeItRounded(width: 0, cornerRadius: setEventLocationButton.frame.height/2)
        setEventLocationButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
    }
    
    func showLoadingView() {
        placeTitleLabel.text = ""
        placeAddressLabel.text = ""
        loadingIndicatorView.startAnimating()
        setEventLocationButton.alpha = 0.0
        self.layoutIfNeeded()
    }
    
    func setContentAddress(place:GooglePlace) {
        selectedPlace = place
        loadingIndicatorView.stopAnimating()
        placeTitleLabel.text = place.placeName
        placeAddressLabel.text = place.description
        setEventLocationButton.alpha = 1.0
        self.layoutIfNeeded()
    }
}
