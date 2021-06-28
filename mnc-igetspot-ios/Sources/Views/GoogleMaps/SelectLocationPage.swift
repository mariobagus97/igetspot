//
//  SelectLocationPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SelectLocationPageDelegate {
    func openSearch()
    func setMaps()
}

class SelectLocationPage: UIView {
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    var delegate : SelectLocationPageDelegate!
    
    
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    var lat : Double!
    var long : Double!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true

//        self.googleMapsView.settings.drag
        
    }
    
    @IBAction func openSearchPage(_ sender: Any) {
        self.delegate?.openSearch()
    }
    
    func animateTo(camera: GMSCameraPosition){
        
        self.googleMapsView.animate(to: camera)
    }
    
    func setCameraToMaps(camera: GMSCameraPosition){
        
        self.googleMapsView.camera = camera
    }
    
    func showPartyMarkers(lat: Double, long: Double) {
        googleMapsView.clear()
        
        
        for i in 0..<3 {
            let randNum = Double(arc4random_uniform(30))/10000
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: UIColor.darkGray, tag: i)
            marker.iconView=customMarker
            let randInt = arc4random_uniform(4)
            if randInt == 0 {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
            } else if randInt == 1 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
            } else if randInt == 2 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
            } else {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
            }
            marker.map = self.googleMapsView
            
            self.lat = lat
            self.long = long
        }
        
    }
    
    func setPlace(place: GMSPlace){
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = googleMapsView
    }
    
    func setMarker(marker : GMSMarker){
        marker.map = self.googleMapsView
//        marker.map = myMapView
    }
}

extension SelectLocationPage : GMSMapViewDelegate {
    
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
//    // MARK: GMSMapview Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapsView.isMyLocationEnabled = true
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

        self.googleMapsView.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }

    }
//
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
//        let img = customMarkerView.img!
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
//
//        marker.iconView = customMarker
//
//        return false
//    }
}



class CustomMarkerView: UIView {
    var borderColor: UIColor!
    
    init(frame: CGRect, borderColor: UIColor, tag: Int) {
        super.init(frame: frame)
        self.borderColor=borderColor
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let lbl=UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        lbl.text = "▾"
        lbl.font=UIFont.systemFont(ofSize: 24)
        lbl.textColor = borderColor
        lbl.textAlignment = .center
        
        self.addSubview(lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
