//
//  ProfileMapsCell.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/26/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import GoogleMaps


class ProfileMapsCell : MKTableViewCell, CLLocationManagerDelegate{
    
    @IBOutlet weak var googleMapView: GMSMapView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func loadView() {
        super.loadView()
        
        setMaps()
        
      
    }
    
    func setMaps(){
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.bounds, camera: camera)
        self.googleMapView = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        
        self.googleMapView?.isMyLocationEnabled = true
        
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.googleMapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
}


