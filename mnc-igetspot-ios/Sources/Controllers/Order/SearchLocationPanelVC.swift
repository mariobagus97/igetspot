////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol SearchLocationPanelVCDelegate:class {
    func locationSearchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    func locationDidSelect(place: GooglePlace)
    func openSelectViaMap()
}

class SearchLocationPanelVC: MKViewController {

    var searchLocationPanelView: SearchLocationPanelView!
    var delegate: SearchLocationPanelVCDelegate?
    var presenter = SearchLocationPanelPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        presenter.attachview(self)
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
    }
    
    func addViews() {
        searchLocationPanelView = SearchLocationPanelView()
        searchLocationPanelView.delegate = self
        
        view.addSubview(searchLocationPanelView)
        searchLocationPanelView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
    }
    
}

// MARK: - SearchLocationPanelDelegate
extension SearchLocationPanelVC: SearchLocationPanelDelegate {
    func showErrorMessage(message: String) {
        showErrorMessageBanner(message)
    }
    
    func setContent(googlePlaces:[GooglePlace]?) {
        searchLocationPanelView.setContent(googlePlaces: googlePlaces)
    }
    
    func locationDidSelect(googlePlace:GooglePlace) {
        delegate?.locationDidSelect(place: googlePlace)
    }
}

// MARK: - SearchLocationPanelViewDelegate
extension SearchLocationPanelVC: SearchLocationPanelViewDelegate {
    func openSelectViaMap() {
        delegate?.openSelectViaMap()
    }
    
    func getPlaceDetail(place:GooglePlace) {
        presenter.getGooglePlacesDetail(googlePlace: place)
    }
    
    func searchBarTextDidChange(searchText: String) {
        presenter.searchGooglePlaces(withInput: searchText)
    }
    
    func locationSearchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.locationSearchBarTextDidBeginEditing(searchBar)
    }
}
