//
//  SearchLocationVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/12/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchLocationVC: MKViewController {
    
    let searchPage = UINib(nibName: "EditSearchAddressPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditSearchAddressPage
    
    var mPresenter = MapsPresenter()
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        
        self.mPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    
    func addView(){
        self.view.addSubview(searchPage)
        
        searchPage.delegate = self
        
        searchPage.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    func removeSelf(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func setTableContent(candidateList : [Candidates]){
        self.searchPage.setTableContent(content: candidateList)
    }
    
    
}

extension SearchLocationVC : EditSearchAddressPageDelegate {
    func textDidChange(searchText: String) {
        self.mPresenter.searchLocation(keyword: searchText)
    }

}

//extension EditProfileBankVC : EditBankAccountPageDelegate {
//    func onUpdatePressed(bankName: String, bankAccountHolder: String, bankAccountNumber: String, passwordLogin: String) {
//        editBankPresenter.editProfile(bankName: bankName, accountHolder: bankAccountHolder, accountNo: bankAccountNumber, password: passwordLogin)
//    }
//
//}


// Handle the user's selection.
extension SearchLocationVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
