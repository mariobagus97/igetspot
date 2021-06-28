////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SelectLocationViaMapVCDelegate:class {
    func setEventLocationButtonDidClicked(place: GooglePlace)
    func closeMapButtonDidClicked()
}

class SelectLocationViaMapVC: MKViewController {

    var selectViaMapView: SelectViaMapView!
    weak var delegate: SelectLocationViaMapVCDelegate?
    var currentPlace:GooglePlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
    }
    
    func addViews() {
        selectViaMapView = SelectViaMapView()
        selectViaMapView.delegate = self
        
        view.addSubview(selectViaMapView)
        selectViaMapView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    func showLoadingView() {
        selectViaMapView.showLoadingView()
    }
    
    func setContentAddress(place:GooglePlace) {
        selectViaMapView.setContentAddress(place: place)
    }
    
}

extension SelectLocationViaMapVC: SelectViaMapViewDelegate {
    func setEventLocationButtonDidClicked(place: GooglePlace) {
        delegate?.setEventLocationButtonDidClicked(place: place)
    }
    
    func closeMapButtonDidClicked() {
        delegate?.closeMapButtonDidClicked()
    }
}
