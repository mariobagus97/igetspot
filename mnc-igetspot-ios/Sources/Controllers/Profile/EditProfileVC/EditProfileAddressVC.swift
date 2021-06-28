//
//  EditProfileAddressVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/9/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import SwiftMessages


class EditProfileAddressVC : MKViewController {
    
    var editAdressPresenter = EditAddressPresenter()
    let editProfileView = UINib(nibName: "EditProfileAddressPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfileAddressPage
    
    var googleMapsView: GMSMapView!
    var searchAddress: EditAddressSearchAddressVC!
    var resultsArray = [String]()
    var gmsFetcher: GMSAutocompleteFetcher!
    var user: UserData?
    let placesClient = GMSPlacesClient()
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        editAdressPresenter.attachview(self)
        addView()
        
        if let user = self.user {
            editProfileView.setAllFields(placeName: user.notes, detail: user.address, country: user.country, city: user.city, province: user.province, postCode: user.zipcode)
            editProfileView.setMaps(long: user.longitude, lat: user.latitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        searchAddress = EditAddressSearchAddressVC()
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
        
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(NSLocalizedString("Edit Address", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func addView(){
        self.view.addSubview(editProfileView)
        editProfileView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        editProfileView.delegate = self
    }
    
    
//    func showAutoComplete(searchText : String){
//        self.resultsArray.removeAll()
//        gmsFetcher?.sourceTextHasChanged(searchText)
//    }
    
    func moveToSearch(){
       // self.navigationController?.pushViewController(SelectLocationVC(), animated: true)
    }
    
    func showAutoComplete(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
    
        var cancelButtonSearchButton : UIButton?
        
        if #available(iOS 11.0, *) {
//            autoCompleteController.navigationController?.navigationBar.
            let cancelButtonSearchButton = autoCompleteController.navigationController?.tabBarItem
//            navigationItem.searchController?.searchBar.value(forKey: "cancelButton") as? UIButton
            
//            cancelButtonSearchButton?.tintColor = UIColor.blue
        } else {
            //
        }
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
}

extension EditProfileAddressVC : CLLocationManagerDelegate {
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
        
//        self.mapsView.animateTo(camera: camera)
        
//        self.mapsView.showPartyMarkers(lat: lat, long: long)
    }
    
}

extension EditProfileAddressVC : GMSAutocompleteViewControllerDelegate {
    
    func initGoogleMaps() {
        
        locationManager.startUpdatingLocation()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        
//        self.mapsView.showPartyMarkers(lat: lat, long: long)
        
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
//        self.mapsView.animateTo(camera: camera)
        
        print("Google maps ID: \(place.placeID)")
        
//        self.mapsView.setPlace(place: place)
        
        if let placeID = place.placeID {
            self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                if error != nil {
                    print("lookup place id query error: \(error!.localizedDescription)")
                    return
                }
                
                if let p = place {
                    var province : String = ""
                    var city : String = ""
                    var country : String = ""
                    var postalCode = ""
    
                    let addressComponents = p.addressComponents
                    for component in addressComponents! {
                        if component.type == "administrative_area_level_1" {
                            province = component.name
                        }
                        if component.type == "administrative_area_level_2" {
                            city = component.name
                        }
                        if component.type == "country" {
                            country = component.name
                        }
                        if component.type == "postal_code" {
                            postalCode = component.name
                        }
                    }
                    
                    self.editProfileView.setAllFields(placeName: p.formattedAddress ?? "" ,detail: "", country: country, city: city, province: province, postCode: postalCode )
                    
                } else {
                    print("No place details for \(placeID)")
                }
            })
            
            self.editProfileView.setMaps(long: long, lat: lat)
            
        }
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
}

extension EditProfileAddressVC : EditProfileAddressPageDelegate{
    func showSearchVC() {
        showAutoComplete()
    }
    
    func onUpdatePressed(address: String, latitude: Double, longitude: Double, detail: String, country: String, city: String, province: String, zipcode: String, password: String) {
        editAdressPresenter.editAddress(address: address, latitude: latitude, longitude: longitude, detail: detail, country: country, city: city, province: province, zipcode: zipcode, password: password)
    }
    
}

extension EditProfileAddressVC : LocateOnTheMap{
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
//        DispatchQueue.main.async {
//            () -> Void in
//
//            let position = CLLocationCoordinate2DMake(lat, lon)
//            let marker = GMSMarker(position: position)
//
//            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
//            self.googleMapsView.camera = camera
//
//            marker.title = "Address : \(title)"
//            marker.map = self.googleMapsView
//
//        }
        
    }
}

extension EditProfileAddressVC : GMSAutocompleteFetcherDelegate{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        for prediction in predictions {
            
            if let prediction = prediction as? GMSAutocompletePrediction {
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        
        print(resultsArray)
        
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        //
    }
}

class CustomAutoCompleteSegue: SwiftMessagesSegue {
    
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .bottomCard)
        containerView.cornerRadius = 10
    }
    
}

extension EditProfileAddressVC : EditAddressView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showSuccessMessage(_ message: String) {
        showSuccessMessageBanner(message)
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
}
