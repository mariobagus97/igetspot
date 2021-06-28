//
//  EditProfileAddressVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/9/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

protocol LocateOnTheMap{
    func locateWithLongitude(_ lon:Double, andLatitude lat:Double, andTitle title: String)
}

class EditAddressSearchAddressVC : MKTableViewController {
    
    var section = MKTableViewSection()
    var cell : MySpotPickerTableViewCell!
    var searchCell : EditAddressSearchBarPage!
    
    var searchResults = [String]()
    var delegate : LocateOnTheMap!
    
    var itemList = [String]()
    
    var categoryList = [AllServices]()
    
    var subCategoryList = [SubCategories]()
    
    let category = 1
    let subcategory = 2
    let nameOfString = 3
    
    var itemType : Int!
    var gmsFetcher: GMSAutocompleteFetcher!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.editAddressSearchBarPage.name) as? EditAddressSearchBarPage
        
        searchCell.cellDelegate = self
        section.appendRow(cell: searchCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.gmsFetcher = GMSAutocompleteFetcher()
        self.gmsFetcher.delegate = self
    }
    
    override func registerNibs() {
        super.registerNibs()
        contentView.registeredCellIdentifiers.append(R.nib.mySpotPickerTableViewCell.name)
        contentView.registeredCellIdentifiers.append(R.nib.editAddressSearchBarPage.name)
    }
    
    override func createSections() {
        super.createSections()
        contentView.appendSection(section)
    }
    
    override func createRows() {
        super.createRows()
        addRows()
    }
    
    func setItemList(list: [String]){
        self.itemType = nameOfString
        self.itemList = list
    }
    
    func setCategoryList(list : [AllServices]){
        self.itemType = category
        self.categoryList.append(contentsOf: list)
        for item in list {
            self.itemList.append(item.categoryMenu ?? "")
        }
    }
    
    func setSubCategoryList(list : [SubCategories]){
        self.itemType = subcategory
        self.subCategoryList.append(contentsOf: list)
        for item in list {
            self.itemList.append(item.subcategoryName ?? "")
        }
    }
    
    func addRows(){
        if (searchResults.count > 0){
            for row in 0...searchResults.count-1 {
                cell = contentView.dequeueReusableCellWithIdentifier(nibName: R.nib.mySpotPickerTableViewCell.name) as? MySpotPickerTableViewCell
                
//                cell.delegate = self
                
                cell.setItem(id:row, name: self.searchResults[row])
                
                section.appendRow(cell: cell)
                
            }
        }
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        self.dismiss(animated: true, completion: nil)
//        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        
//        let url = URL(string: urlpath!)
//        
//        let task = URLSession.shared.dataTask(with: (url)!)
//        {
//            (data, response, error) in
//            
//            print(data!)
//            
//            do
//            {
//                if data != nil
//                {
//                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
//                    
//                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
//                    
//                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
//                    
//                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
//                }
//                
//            }catch let error
//            {
//                print(error)
//            }
//            
//            
//        }
//        task.resume()
//        
//    }
    
//    func reloadDataWithArray(_ array:[String]){
//        self.searchResults = array
//        self.tableView.reloadData()
//    }
    
//    var searchResults:[String]!
//    var delegate : LocateOnTheMap!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.searchResults = Array()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "maptableviewcell")
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchResults.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "maptableviewcell", for: indexPath)
//        cell.textLabel?.text = searchResults[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        self.dismiss(animated: true, completion: nil)
//        let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.searchResults[indexPath.row])&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        let url = URL(string: urlpath!)
//
//        let task = URLSession.shared.dataTask(with: (url)!)
//        {
//            (data, response, error) in
//
//            print(data!)
//
//            do
//            {
//                if data != nil
//                {
//                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
//
//                    let lat =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lat")) as! Double
//
//                    let lon =   (((((dic.value(forKey: "results") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "geometry") as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "lng")) as! Double
//
//                    self.delegate.locateWithLongitude(lon, andLatitude: lat, andTitle: self.searchResults[indexPath.row])
//                }
//
//            }catch let error
//            {
//                print(error)
//            }
//
//
//        }
//        task.resume()
//
//    }
//    func reloadDataWithArray(_ array:[String]){
//        self.searchResults = array
//        self.tableView.reloadData()
//    }
//
    
}

extension EditAddressSearchAddressVC : GMSAutocompleteFetcherDelegate{
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        //self.resultsArray.count + 1
        
        var resultsArray = [String]()
        
        for prediction in predictions {
            resultsArray.append(prediction.attributedFullText.string)
        }
        
        self.searchResults.removeAll()
        self.contentView.reloadData()
        self.searchResults = resultsArray
        self.createRows()
        self.contentView.reloadData()
        
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("autocomplete error: \(error.localizedDescription)")
    }
    
    
}

extension EditAddressSearchAddressVC : EditAddressSearchBarPageDelegate {
    func textDidChange(searchText: String){
        self.gmsFetcher?.sourceTextHasChanged(searchText)
    }
}
