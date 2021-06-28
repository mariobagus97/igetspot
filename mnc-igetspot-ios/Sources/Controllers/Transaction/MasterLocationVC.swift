////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol MasterLocationVCDelegate:class {
    func masterLocationCloseButtonDidClicked()
    func callMasterButtonDidClicked()
    func chatMasterButtonDidClicked()
}

class MasterLocationVC: MKViewController {
    
    weak var delegate: MasterLocationVCDelegate?
    var headerView: FloatingPanelHeaderView!
    var mapView: GMSMapView!
    let marker = GMSMarker()
    var mockCoordinate = CLLocationCoordinate2D(latitude: -6.1849305, longitude:  106.8317695)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addViews()
        setupConstraints()
        addMarkerLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Master’s Location", comment: "")
        headerView.setIconTitle()
        view.addSubview(headerView)
        
        mapView = GMSMapView()
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        headerView.snp.makeConstraints{ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        mapView.snp.makeConstraints{ (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo((headerView?.snp.bottom)!).offset(0)
        }
    }
    
    func addMarkerLocation() {
        let camera = GMSCameraPosition(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude, zoom: 15)
        
        marker.position = mockCoordinate
        marker.icon = R.image.pinLocationColor()
        marker.map = mapView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.mapView.animate(to: camera)
        }
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension MasterLocationVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.masterLocationCloseButtonDidClicked()
    }
}

// MARK: - GMSMapViewDelegate
extension MasterLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView else {
            return nil
        }
        infoView.masterNameLabel.text = "Kurt Cobain"
        infoView.masterOfLabel.text = "Singer"
        
        return infoView
    }
    
}
