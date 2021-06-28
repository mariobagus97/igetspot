////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import FloatingPanel

protocol OrderDetailSelectLocationVCDelegate:class {
    func locationDidSelect(place:GooglePlace)
}

class OrderDetailSelectLocationVC: MKViewController {
    
    var orderDetailSelectLocationView: OrderDetailSelectLocationView!
    private let locationManager = CLLocationManager()
    var fpc: FloatingPanelController!
    var searchVC: SearchLocationPanelVC!
    var currentPlace: GooglePlace?
    weak var delegate:OrderDetailSelectLocationVCDelegate?
    var selectViaMapFPC: FloatingPanelController!
    var selectLocationViaMapVC: SelectLocationViaMapVC?
    var presenter = OrderDetailSelectLocationPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        presenter.attachview(self)
        addViews()
        
        setupSearchLocationPanel()
        setupCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  Add FloatingPanel to a view with animation.
        fpc.addPanel(toParent: self, animated: true)
        
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Select Location", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func addViews() {
        orderDetailSelectLocationView = OrderDetailSelectLocationView()
        orderDetailSelectLocationView.mapView.delegate = self
        
        view.addSubview(orderDetailSelectLocationView)
        orderDetailSelectLocationView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
    func setupCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func setupSearchLocationPanel() {
        // Do any additional setup after loading the view, typically from a nib.
        // Initialize FloatingPanelController
        fpc = FloatingPanelController()
        fpc.delegate = self
        
        // Initialize FloatingPanelController and add the view
        fpc.surfaceView.backgroundColor = .clear
        fpc.surfaceView.cornerRadius = 9.0
        fpc.surfaceView.shadowHidden = false
        
        searchVC = SearchLocationPanelVC()
        searchVC.delegate = self
        // Set a content view controller
        fpc.set(contentViewController: searchVC)
        fpc.track(scrollView: searchVC.searchLocationPanelView.tableView)
    }
    
    func showSelectViaMapPanel() {
        // Do any additional setup after loading the view, typically from a nib.
        // Initialize FloatingPanelController
        selectViaMapFPC = FloatingPanelController()
        selectViaMapFPC.panGestureRecognizer.isEnabled = false
        selectViaMapFPC.isRemovalInteractionEnabled = false
        selectViaMapFPC.delegate = self
        
        // Initialize FloatingPanelController and add the view
        selectViaMapFPC.surfaceView.backgroundColor = .clear
        selectViaMapFPC.surfaceView.cornerRadius = 9.0
        selectViaMapFPC.surfaceView.shadowHidden = false
        
        selectLocationViaMapVC = SelectLocationViaMapVC()
        selectLocationViaMapVC?.delegate = self
        
        // Set a content view controller
        selectViaMapFPC.set(contentViewController: selectLocationViaMapVC!)
        
        selectViaMapFPC.addPanel(toParent: self, animated: true)
    }
}

// MARK: - OrderDetailSelectLocationDelegate
extension OrderDetailSelectLocationVC: OrderDetailSelectLocationDelegate {
    func setCurrentPlace(place:GooglePlace) {
        currentPlace = place
        selectLocationViaMapVC?.setContentAddress(place: place)
        if (selectViaMapFPC != nil) {
            selectViaMapFPC.updateLayout()
        }
    }
}

// MARK: - GMSMapViewDelegate
extension OrderDetailSelectLocationVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        presenter.reverseGeocodeCoordinate(position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        selectLocationViaMapVC?.showLoadingView()
    }
}

// MARK: - SelectLocationViaMapVCDelegate
extension OrderDetailSelectLocationVC: SelectLocationViaMapVCDelegate {
    func setEventLocationButtonDidClicked(place: GooglePlace) {
        selectViaMapFPC.removePanelFromParent(animated: true)
        selectViaMapFPC = nil
        delegate?.locationDidSelect(place: place)
        navigationController?.popViewController(animated: true)
    }
    
    func closeMapButtonDidClicked() {
        selectViaMapFPC.removePanelFromParent(animated: true)
        selectViaMapFPC = nil
        fpc.move(to: .half , animated: true)
        orderDetailSelectLocationView.mapCenterPinImage.alpha = 0.0
    }
}

// MARK: - UISearchBarDelegate
extension OrderDetailSelectLocationVC: SearchLocationPanelVCDelegate {
    func openSelectViaMap() {
        fpc.move(to: .hidden, animated: true)
        showSelectViaMapPanel()
        orderDetailSelectLocationView.mapCenterPinImage.alpha = 1.0
        if let currentPlace = self.currentPlace {
            setCurrentPlace(place: currentPlace)
        }
    }
    
    func locationSearchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        fpc.move(to: .full, animated: true)
    }
    
    func locationDidSelect(place: GooglePlace) {
        fpc.move(to: .half, animated: true)
        delegate?.locationDidSelect(place: place)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - FloatingPanelControllerDelegate
extension OrderDetailSelectLocationVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        if vc == fpc {
            switch newCollection.verticalSizeClass {
            case .compact:
                fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
                fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
                return SearchPanelLandscapeLayout()
            default:
                fpc.surfaceView.borderWidth = 0.0
                fpc.surfaceView.borderColor = nil
                return nil
            }
        } else if vc == selectViaMapFPC {
            return LocationPanelLayout()
        }
        return nil
    }
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        let y = vc.surfaceView.frame.origin.y
        let tipY = vc.originYOfSurface(for: .tip)
        if y > tipY - 44.0 {
            let progress = max(0.0, min((tipY  - y) / 44.0, 1.0))
            self.searchVC.searchLocationPanelView.tableView.alpha = progress
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.position == .full {
            searchVC.searchBar.showsCancelButton = false
            searchVC.searchBar.resignFirstResponder()
        }
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition != .full {
            //searchVC.hideHeader()
            view.endEditing(true)
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                        if targetPosition == .tip {
                            self.searchVC.searchLocationPanelView.tableView.alpha = 0.0
                        } else {
                            self.searchVC.searchLocationPanelView.tableView.alpha = 1.0
                        }
        }, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension OrderDetailSelectLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        orderDetailSelectLocationView.mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        let coordinate = location.coordinate
        orderDetailSelectLocationView.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
}

class LocationPanelLayout: FloatingPanelIntrinsicLayout {
    var topInteractionBuffer: CGFloat {
        return 100.0
    }
    
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}


public class SearchPanelLandscapeLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip, .hidden]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0
        case .tip: return 69.0
        default: return nil
        }
    }
    
    public func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        if #available(iOS 11.0, *) {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        } else {
            return [
                surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
                surfaceView.widthAnchor.constraint(equalToConstant: 291),
            ]
        }
    }
    
    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}
