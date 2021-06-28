//
//  EditAddressSearchBarPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/7/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditAddressSearchBarPageDelegate {
    func textDidChange(searchText: String)
}

class EditAddressSearchBarPage: MKTableViewCell {
    
    var cellDelegate : EditAddressSearchBarPageDelegate!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.searchBar.delegate = self
    }
}

extension EditAddressSearchBarPage : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cellDelegate?.textDidChange(searchText: searchText)
//        self.resultsArray.removeAll()
//        gmsFetcher?.sourceTextHasChanged(searchText)
    }
}
