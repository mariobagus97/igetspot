//
//  EditSearchAddressPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 2/11/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol EditSearchAddressPageDelegate {
    func textDidChange(searchText: String)
}

class EditSearchAddressPage: UIView {
    
    @IBOutlet weak var searchLocation: UISearchBar!
 
    @IBOutlet weak var autoCompleteTable: UITableView!
    
    @IBOutlet weak var selectMapView: UIView!
    
    @IBOutlet weak var roundedDash: UIView!
    
    var section = MKTableViewSection()
    
    var candidatesList = [Candidates]()
    
    var delegate : EditSearchAddressPageDelegate!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        initTable()
        searchLocation.delegate = self
        
    }
    
    func initTable(){
        autoCompleteTable.delegate = self
        autoCompleteTable.dataSource = self
        self.autoCompleteTable.register(MySpotPickerTableViewCell.self, forCellReuseIdentifier: R.nib.mySpotPickerTableViewCell.name)
    }
    
    @IBAction func onHideClicked(_ sender: Any) {
        
    }
    
    func setTableContent(content: [Candidates]){
        self.candidatesList.append(contentsOf: content)
        self.autoCompleteTable.reloadData()
    }
    
}

extension EditSearchAddressPage : UITableViewDelegate {
    
}

extension EditSearchAddressPage : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candidatesList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MySpotPickerTableViewCell = self.autoCompleteTable.dequeueReusableCell(withIdentifier: R.nib.mySpotPickerTableViewCell.name) as! MySpotPickerTableViewCell
        
        cell.setItem(id: indexPath.row, name: self.candidatesList[indexPath.row].name ?? "dddd")
        
        return cell
    }
    
    
}

extension EditSearchAddressPage : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.textDidChange(searchText: searchText)
    }
}
