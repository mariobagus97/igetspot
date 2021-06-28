//
//  EditProfileAddressPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/9/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol EditProfileAddressPageDelegate {
    func onUpdatePressed(address: String, latitude: Double, longitude: Double, detail: String, country: String, city: String, province: String, zipcode: String, password: String)
    func showSearchVC()
}

class EditProfileAddressPage : UIView{
    
    var delegate : EditProfileAddressPageDelegate?
    
    @IBOutlet weak var searchCoordinateField: UITextView!
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var provinceField: UITextField!
    @IBOutlet weak var postCodeField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var detailheight: NSLayoutConstraint!
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    var long = 0.0
    var lat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateButton.makeItRounded(width:0.0, cornerRadius : self.updateButton.bounds.height / 2)
        self.updateButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
//        setMaps()
        
        
//        detailField.isUserInteractionEnabled = false
        self.mapsView.delegate = self
//        self.mapsView.isMyLocationEnabled = true
        self.mapsView.settings.myLocationButton = true
        self.detailField.delegate = self
        self.searchCoordinateField.delegate = self
        
        addGesture()
    }
    
    func showUserData(long: String, lat: String, detailBuilding: String, country: String, province: String, postCode:String){
    
    }
    
    func addGesture(){
        searchCoordinateField.isUserInteractionEnabled = true
        searchCoordinateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSearchClicked(_:))))
    }
    
    
    @objc func onSearchClicked(_ sender: UITapGestureRecognizer){
        self.delegate?.showSearchVC()
    }
    
    
    func setMaps(long: Double, lat: Double){
        
        self.long = long
        self.lat = lat
        
        if mapsView != nil {
//            self.mapsView.isMyLocationEnabled = true
            // Create a GMSCameraPosition that tells the map to display the
            // coordinate -33.86,151.20 at zoom level 6.
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
//            let mapView = GMSMapView.map(withFrame: self.bounds, camera: camera)
//            self.mapsView = mapView
            mapsView.animate(to: camera)
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
            marker.map = mapsView
            
            
            setNeedsLayout()
            layoutIfNeeded()
            
        
        }
        
    }
    
    func setAllFields(placeName:String, detail: String, country: String, city: String, province: String, postCode: String ){
        detailField.text = ""
        countryField.text = ""
        cityField.text = ""
        provinceField.text = ""
        postCodeField.text = ""
        
        if (placeName != ""){
            searchCoordinateField.text = placeName
            searchCoordinateField.textColor = .black
            var newFrame = self.searchCoordinateField.frame
            let width = newFrame.size.width
            let newSize = self.searchCoordinateField.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            if newSize.height > searchHeight.constant {
                newFrame.size = CGSize(width: width, height: newSize.height)
                searchCoordinateField.frame = newFrame
                self.searchHeight.constant = newSize.height
                self.searchCoordinateField.setNeedsLayout()
                self.searchCoordinateField.layoutIfNeeded()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
        
        if (detail != ""){
            detailField.text = detail
        } else {
            detailField.isUserInteractionEnabled = true
        }
        
        if(country != ""){
            countryField.text = country
        } else {
            countryField.isUserInteractionEnabled = true
        }
        
        if(city != ""){
            cityField.text = city
        } else {
            cityField.isUserInteractionEnabled = true
        }
        
        if(province != ""){
            provinceField.text = province
        } else {
            provinceField.placeholder = "Input province"
            provinceField.isUserInteractionEnabled = true
        }
        
        if(postCode != ""){
            postCodeField.text = postCode
        } else {
            postCodeField.placeholder = "Input post code"
            postCodeField.isUserInteractionEnabled = true
        }
        
        layoutIfNeeded()
    }
    
    
    @IBAction func onUpdatePressed(_ sender: Any) {
        self.delegate?.onUpdatePressed(address: detailField.text ?? "", latitude: self.lat, longitude: self.long, detail: "\(detailField.text ?? "") \(searchCoordinateField.text ?? "")", country: countryField.text ?? "", city: cityField.text ?? "", province: provinceField.text ?? "", zipcode:  postCodeField.text!, password: passwordField.text ?? "")
//        self.delegate?.onUpdatePressed(fullname: self.nameField.text ?? "", username: self.userNameField.text ?? "", birthdate: self.birthDateView.text ?? "")
    }
   
}

extension EditProfileAddressPage : GMSMapViewDelegate {
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerzHeight), borderColor: UIColor.white, tag: customMarkerView.tag)
        
//        marker.iconView = customMarker
        
        return false
    }
    
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), borderColor: UIColor.darkGray, tag: customMarkerView.tag)
//        marker.iconView = customMarker
    }
    
    //    // MARK: GMSMapview Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        mapView.isMyLocationEnabled = true
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


extension EditProfileAddressPage : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var newFrame = self.detailField.frame
        let width = newFrame.size.width
        let newSize = self.detailField.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > detailheight.constant {
            newFrame.size = CGSize(width: width, height: newSize.height)
            textView.frame = newFrame
            self.detailheight.constant = newSize.height
            self.detailField.setNeedsLayout()
            self.detailField.layoutIfNeeded()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
