////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation
import SwiftyJSON
import GooglePlaces

protocol SearchLocationPanelDelegate:class {
    func setContent(googlePlaces:[GooglePlace]?)
    func locationDidSelect(googlePlace:GooglePlace)
    func showErrorMessage(message:String)
}

class SearchLocationPanelPresenter: MKPresenter {
    
    private weak var searchLocationPanelView: SearchLocationPanelDelegate?
    private var googlePlaceService: GooglePlaceService?
    private var placesClient: GMSPlacesClient?
    
    override init() {
        super.init()
        googlePlaceService = GooglePlaceService()
        placesClient = GMSPlacesClient()
    }
    
    func attachview(_ view: SearchLocationPanelDelegate) {
        self.searchLocationPanelView = view
    }
    
    func searchGooglePlaces(withInput input:String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient?.autocompleteQuery(input, bounds: nil, filter: filter, callback: { (results, error) -> Void in
            if error != nil {
                self.searchLocationPanelView?.setContent(googlePlaces: nil)
                self.searchLocationPanelView?.showErrorMessage(message:error?.localizedDescription ?? NSLocalizedString("Ooops, something went wrong, please try again", comment: ""))
            }
            guard let placeArray = results, placeArray.count > 0 else {
                self.searchLocationPanelView?.setContent(googlePlaces: nil)
                return
            }
            var googlePlaceArray = [GooglePlace]()
            for place in placeArray {
                let googlePlace = GooglePlace()
                googlePlace.placeName = place.attributedPrimaryText.string
                googlePlace.placeId = place.placeID
                googlePlace.description = place.attributedFullText.string
                googlePlace.address = place.attributedSecondaryText?.string
                googlePlaceArray.append(googlePlace)
            }
            self.searchLocationPanelView?.setContent(googlePlaces: googlePlaceArray)
        })
        
    }
    
    func getGooglePlacesDetail(googlePlace:GooglePlace) {
        guard let placeId = googlePlace.placeId else {return}
        placesClient?.lookUpPlaceID(placeId, callback: { (place, error) in
            if error != nil {
                self.searchLocationPanelView?.showErrorMessage(message:error?.localizedDescription ?? NSLocalizedString("Ooops, something went wrong, please try again", comment: ""))
            } else {
                guard let placeDetail = place else {
                    return
                }
                let latitude = Double(placeDetail.coordinate.latitude)
                let longitude = Double(placeDetail.coordinate.longitude)
                googlePlace.latitude = latitude
                googlePlace.longitude = longitude
                self.searchLocationPanelView?.locationDidSelect(googlePlace: (googlePlace))
            }
        })
    }

}
