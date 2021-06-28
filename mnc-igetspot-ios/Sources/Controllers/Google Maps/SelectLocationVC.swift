//
//  SelectLocationVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SnapKit

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class SelectLocationVC: MKViewController {
    
    
    let mapsView = UINib(nibName: "SelectLocationPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SelectLocationPage
    
//    @IBOutlet weak var googleMapsView: GMSMapView!
    
    // VARIABLES
    var locationManager = CLLocationManager()
    
    
    var chosenPlace: MyPlace?
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder="Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupViews()
    }
 
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Select Location", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    func setupViews(){
        self.view.addSubview(mapsView)
        mapsView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        mapsView.delegate = self
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        
//        let autoCompleteController = GMSAutocompleteViewController()
//        autoCompleteController.delegate = self
//
//        let filter = GMSAutocompleteFilter()
//        autoCompleteController.autocompleteFilter = filter
//
//        self.locationManager.startUpdatingLocation()
//        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    
    
}

extension SelectLocationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.mapsView.animateTo(camera: camera)
        
        self.mapsView.showPartyMarkers(lat: lat, long: long)
    }

}

extension SelectLocationVC : GMSAutocompleteViewControllerDelegate {
    
    func initGoogleMaps() {
        
        locationManager.startUpdatingLocation()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        
        self.mapsView.showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        self.mapsView.animateTo(camera: camera)
        
        self.mapsView.setPlace(place: place)
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
}

extension SelectLocationVC : SelectLocationPageDelegate {
    
    func openSearch(){
//        let vc = SearchLocationVC()
        let vc = GMSAutocompleteViewController()
        vc.preferredContentSize = CGSize(width: 0, height: self.view.bounds.height / 3)
        
        let nc = UINavigationController(rootViewController: vc)
        
        nc.isNavigationBarHidden = true
        
        let popupSegue = CustomAutoCompleteSegue(identifier: nil,
                                                 source: self,
                                                 destination: nc)
//        popupSegue.perform()
//        let autoCompleteController = GMSAutocompleteViewController()
//        autoCompleteController.delegate = self
//
//        self.locationManager.startUpdatingLocation()
//        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func setMaps(){
        
    }
}
