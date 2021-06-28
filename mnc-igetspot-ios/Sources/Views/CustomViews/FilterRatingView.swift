//
//  FilterRatingView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 04/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol FilterRatingViewDelegate {
    func filterRatingDidSelect(selectedRating rating:Int)
}

class FilterRatingView: UIView {
    @IBOutlet weak var allRatingButton: UIButton!
    @IBOutlet weak var oneStarRatingButton: UIButton!
    @IBOutlet weak var twoStarRatingButton: UIButton!
    @IBOutlet weak var threeStarRatingButton: UIButton!
    @IBOutlet weak var fourStarRatingButton: UIButton!
    @IBOutlet weak var fiveStarRatingButton: UIButton!
    var selectedButton : UIButton?
    var delegate: FilterRatingViewDelegate?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
    }
    
    // MARK: - Private Functions
    private func adjustLayout() {
        allRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
        oneStarRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
        twoStarRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
        threeStarRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
        fourStarRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
        fiveStarRatingButton.makeItRounded(borderColor: Colors.selectedGray.cgColor, cornerRadius: 5)
    }

    private func updateRating(withClickedButton button:UIButton) {
        
        if selectedButton == button {
            selectedButton = nil
            updateUnselectedButton(button: button)
        } else {
            if let selectedButton = self.selectedButton {
                updateUnselectedButton(button: selectedButton)
            }
            selectedButton = button
            updateSelectedButton(button: button)
            var selectedRating = 0
            switch (button) {
            case oneStarRatingButton:
                selectedRating = 1
                break
            case twoStarRatingButton:
                selectedRating = 2
                break
            case threeStarRatingButton:
                selectedRating = 3
                break
            case fourStarRatingButton:
                selectedRating = 4
                break
            case fiveStarRatingButton:
                selectedRating = 5
                break
            default:
                // all rating
                selectedRating = 0
                break
            }
            
            delegate?.filterRatingDidSelect(selectedRating: selectedRating)
        }
        
    }
    
    private func updateSelectedButton(button:UIButton) {
        button.backgroundColor = Colors.selectedGray
        button.setTitleColor(UIColor.white, for: .normal)
        if button != allRatingButton {
            button.setImage(R.image.starYellowSmall(), for: .normal)
        }
        
    }
    
    private func updateUnselectedButton(button:UIButton) {
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        if button != allRatingButton {
            button.setImage(R.image.starGreySmall(), for: .normal)
        }
    }
    
    // MARK: - Publics Function
    func setCurrentSelectedRating(currentRating:String) {
        switch currentRating {
        case "1":
            updateRating(withClickedButton: oneStarRatingButton)
        case "2":
            updateRating(withClickedButton: twoStarRatingButton)
        case "3":
            updateRating(withClickedButton: threeStarRatingButton)
        case "4":
            updateRating(withClickedButton: fourStarRatingButton)
        case "5":
            updateRating(withClickedButton: fiveStarRatingButton)
        default:
            updateRating(withClickedButton: allRatingButton)
        }
    }
    
    // MARK: - Actions
    @IBAction func allRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
    
    @IBAction func oneRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
    
    @IBAction func twoRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
    
    @IBAction func threeRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
    
    @IBAction func fourRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
    
    @IBAction func fiveRatingButtonDidClicked(_ button:UIButton) {
        updateRating(withClickedButton: button)
    }
}
