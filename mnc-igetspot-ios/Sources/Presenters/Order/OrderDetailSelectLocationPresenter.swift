////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol OrderDetailSelectLocationDelegate:class {
    func setCurrentPlace(place:GooglePlace)
}

class OrderDetailSelectLocationPresenter: MKPresenter {
    
    private weak var orderDetailSelectLocationView: OrderDetailSelectLocationDelegate?
    
    override init() {
        super.init()
    }
    
    func attachview(_ view: OrderDetailSelectLocationDelegate) {
        self.orderDetailSelectLocationView = view
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        reverseGeocoding(latitude: latitude, longitude: longitude)
    }
    
    func reverseGeocoding(latitude:Double, longitude:Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { [weak self] response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            let joinedAddress = lines.joined(separator: "\n")
            let splitAddress = joinedAddress.components(separatedBy: ",")
            var placeName = ""
            if splitAddress.count > 0 {
                placeName = splitAddress[0]
            }
            let place = GooglePlace()
            place.latitude = latitude
            place.longitude = longitude
            place.description = joinedAddress
            place.placeName = placeName
            place.address = lines.joined(separator: "\n")
            self?.orderDetailSelectLocationView?.setCurrentPlace(place: place)
        }
    }
}
