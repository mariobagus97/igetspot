//
//  MySpotRegistrationPage.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/31/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol MySpotRegistrationPageDelegate:class {
    func onAddPressed(position: Int)
    func onCellImagePressed(pos: Int, index: Int)
    func onContinuePressed()
    func showAlert()
    func onDeleteCategory(position: Int)
    func onAddMorePressed()
    func onDeleteImagePressed(pos:Int, index: Int)
    func showCategoryPicker(position: Int)
    func showSubCategoryPicker(position: Int)
    func showDurationPicker(position: Int)
}


class MySpotRegistrationPage : UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var continueButton: UIButton!
    weak var delegate : MySpotRegistrationPageDelegate?
    var spotRegistrationCell = [MySpotRegistrationWhatToOfferCell]()
    let add = UINib(nibName: "ItemAddMoreCategoryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ItemAddMoreCategoryCell
    let button = UINib(nibName: "ProfileEditButtonCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileEditButtonCell
    let formMaxLimit = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addView(position: 0)
        setSelectedPhotos(position: 0, imageList: [UIImage]())
        addButtonView()
    }
    
    func setTItleContinueButton(title:String) {
        self.button.setTitle(title: title)
    }
    
    @IBAction func onContinuePressed(_ sender: Any) {
        
    }
    
    func addButtonView(){
        self.stackView.addArrangedSubview(add)
        self.stackView.addArrangedSubview(button)
        
        self.button.delegate = self
        self.button.loadView()
        
        self.add.loadView()
        self.add.delegate = self
        
    }
    
    func addView(position: Int) {
        
        spotRegistrationCell.append(UINib(nibName: "MySpotRegistrationWhatToOfferCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MySpotRegistrationWhatToOfferCell)
        
        spotRegistrationCell[
            self.spotRegistrationCell.count - 1].cellDelegate = self
        
        spotRegistrationCell[self.spotRegistrationCell.count - 1].position = position
        
        spotRegistrationCell[self.spotRegistrationCell.count - 1].checkPosition()
        
        self.stackView.insertArrangedSubview(
            spotRegistrationCell[
                self.spotRegistrationCell.count - 1], at: position)
        
        for view in self.stackView.arrangedSubviews {
            view.sizeToFit()
            view.layoutIfNeeded()
        }
        
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func deleteSubView (position: Int) {
        stackView.arrangedSubviews[position].removeFromSuperview()
        spotRegistrationCell.remove(at: position)
        
        self.delegate?.onDeleteCategory(position: position)
        
        for view in stackView.arrangedSubviews {
            view.sizeToFit()
            view.layoutIfNeeded()
        }
        
        // update position
        for index in 0..<spotRegistrationCell.count {
            let cell = spotRegistrationCell[index]
            cell.position = index
        }
        
        if (spotRegistrationCell.count < formMaxLimit) {
            self.button.removeFromSuperview()
            if (!add.isDescendant(of: stackView)){
                self.add.removeFromSuperview()
                self.stackView.addArrangedSubview(add)
                add.delegate = self
            }
            
            self.stackView.addArrangedSubview(button)
            self.button.delegate = self
            self.button.loadView()
        }
        
        stackView.sizeToFit()
        stackView.layoutIfNeeded()
        layoutIfNeeded()
    }
    
    func setSelectedPhotos(position: Int, imageList: [UIImage]){
        spotRegistrationCell[position].setSelectedPhotos(imageList: imageList)
    }
    
    func getData() -> [MySpotWhatToOffer]{
        var data = [MySpotWhatToOffer]()
        
        for i in 0...spotRegistrationCell.count-1 {
            data.append(spotRegistrationCell[i].getData())
        }
        
        return data
    }
    
    func setCategoryField(position: Int, id: Int, name: String){
        spotRegistrationCell[position].setCategory(id: id, name: name)
    }
    
    func setSubCategoryField(position: Int, id: Int, name: String){
        spotRegistrationCell[position].setSubCategory(id: id, name: name)
    }
    
    func resetSubCategoryField(position: Int) {
        spotRegistrationCell[position].setSubCategory(id: 0, name: "")
    }
    
    func setDuration(position:Int, name:String){
        spotRegistrationCell[position].setDuration(name: name)
    }
    
}

extension MySpotRegistrationPage : ItemAddMoreCategoryCellDelegate{
    func onAddPressed(){
        let position = stackView.arrangedSubviews.count-2
        self.delegate?.onAddMorePressed()
        self.addView(position: position)
        setSelectedPhotos(position: position, imageList: [UIImage]())
        if (spotRegistrationCell.count == formMaxLimit){
            self.add.removeFromSuperview()
        }
    }
}

extension MySpotRegistrationPage : ProfileEditButtonCellDelegate{
    func onButtonPressed(){
        self.delegate?.onContinuePressed()
    }
}

extension MySpotRegistrationPage : MySpotRegistrationWhatToOfferCellDelegate{
    func showListDuration(position: Int) {
        self.delegate?.showDurationPicker(position: position)
    }
    
    func deleteCellImage(position: Int, index: Int) {
        self.delegate?.onDeleteImagePressed(pos: position, index: index)
    }

    func onAddPressed(position: Int){
        self.delegate?.onAddPressed(position: position)
    }
    
    func onCellPressed(position: Int, index: Int) {
        self.delegate?.onCellImagePressed(pos: position, index: index)
    }
    
    func onDeletePressed(position: Int) {
        deleteSubView(position: position)
    }
    
    func showCategoryPicker(position: Int) {
        self.delegate?.showCategoryPicker(position: position)
    }
    
    func showSubCategoryPicker(position: Int) {
        self.delegate?.showSubCategoryPicker(position: position)
    }
    
}

