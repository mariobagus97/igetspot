//
//  MySpotPickerTableView.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 1/28/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import SwiftMessages

protocol MySpotPickerTableViewDelegate {
    func setCategory(category: String)
}

class MySpotPickerTableView: MessageView {
    
    @IBOutlet weak var pickerTableView: UITableView!
    
    var cell : UITableViewCell!
    let animals = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    let cellReuseIdentifier = "cell"
    
    var delegate : MySpotPickerTableViewDelegate!
    
    var section : MKTableViewSection!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        pickerTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.pickerTableView.delegate = self
        self.pickerTableView.dataSource = self
        
        self.isUserInteractionEnabled = true
        self.pickerTableView.isUserInteractionEnabled = true
        
        self.pickerTableView.reloadData()
        self.layoutIfNeeded()
    }
    
}

extension MySpotPickerTableView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UITableViewCell
        
        cell.textLabel?.text = animals[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        print(cell.textLabel?.text)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("row is \(indexPath.row)")
//        self.delegate?.setCategory(category: animals[indexPath.row])
//    }
}
