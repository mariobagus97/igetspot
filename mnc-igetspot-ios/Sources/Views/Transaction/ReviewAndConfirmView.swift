////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import Cosmos
import KMPlaceholderTextView

protocol ReviewAndConfirmViewDelegate:class {
    func reviewSubmitButtonDidClicked(serviceQuality:Double, timelinessRating:Double, qualityRating:Double,comment:String)
}

class ReviewAndConfirmView: UIView {
    
    @IBOutlet weak var masterImageView: UIImageView!
    @IBOutlet weak var masterNameLabel: UILabel!
    @IBOutlet weak var masterOfLabel: UILabel!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var serviceQualityButton: UIButton!
    @IBOutlet weak var timelinessButton: UIButton!
    @IBOutlet weak var qualityButton: UIButton!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var submitReviewButton: UIButton!
    var serviceQualityRating:Double = 0.0
    var timelinessRating:Double = 0.0
    var qualityRating:Double = 0.0
    var selectedButton : UIButton?
    weak var delegate:ReviewAndConfirmViewDelegate?
    
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
    
    // MARK: - Layouts
    private func adjustLayout() {
        masterImageView.setRounded()
        serviceQualityButton.makeItRounded(width: 0, cornerRadius: 8)
        timelinessButton.makeItRounded(width: 0, cornerRadius: 8)
        qualityButton.makeItRounded(width: 0, cornerRadius: 8)
        
        submitReviewButton.makeItRounded(width:0.0, cornerRadius : submitReviewButton.bounds.height / 2)
        submitReviewButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        updateCategoryRatingButton(withClickedButton: serviceQualityButton)
        updateUnselectedButton(button: timelinessButton)
        updateUnselectedButton(button: qualityButton)
        
        ratingDidChange()
    }
    
    func setContent(masterImageUrl:String?, masterName:String?, masterOf:String?, packageName:String?, orderDate:String?) {
        masterImageView.load(link: masterImageUrl ?? "", placeholderImage: R.image.userPlacaholder())
        masterNameLabel.text = masterName
        masterOfLabel.text = masterOf
        packageNameLabel.text = packageName
        orderDateLabel.text = orderDate
    }
    
    // MARK: - Actions
    @IBAction func reviewSubmitButtonDidClicked() {
        delegate?.reviewSubmitButtonDidClicked(serviceQuality: serviceQualityRating, timelinessRating: timelinessRating, qualityRating: qualityRating, comment: textView.text)
    }
    
    @IBAction func serviceQualityButtonDidClicked(_ button:UIButton) {
        updateCategoryRatingButton(withClickedButton: button)
    }
    
    @IBAction func timelinessButtonDidClicked(_ button:UIButton) {
        updateCategoryRatingButton(withClickedButton: button)
    }
    
    @IBAction func qualityButtonDidClicked(_ button:UIButton) {
        updateCategoryRatingButton(withClickedButton: button)
    }
    
    // MARK: - Private Functions
    private func ratingDidChange() {
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            
            guard let weakSelf = self else {
                return
            }
            
            switch weakSelf.selectedButton {
            case weakSelf.serviceQualityButton:
                weakSelf.serviceQualityRating = rating
                break
            case weakSelf.timelinessButton:
                weakSelf.timelinessRating = rating
                break
            case weakSelf.qualityButton:
                weakSelf.qualityRating = rating
                break
            default:
                break
            }
            
        }
    }
    private func updateCategoryRatingButton(withClickedButton button:UIButton) {
        
        if selectedButton == button {
            return
        } else {
            if let selectedButton = self.selectedButton {
                updateUnselectedButton(button: selectedButton)
            }
            selectedButton = button
            updateSelectedButton(button: button)
            switch (button) {
            case serviceQualityButton:
                ratingView.rating = serviceQualityRating
                break
            case timelinessButton:
                ratingView.rating = timelinessRating
                break
            case qualityButton:
                ratingView.rating = qualityRating
                break
            default:
                break
            }
        }
    }
    
    private func updateSelectedButton(button:UIButton) {
        button.backgroundColor = Colors.brownishGrey
        button.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    private func updateUnselectedButton(button:UIButton) {
        button.backgroundColor = Colors.unselectGray
        button.setTitleColor(Colors.brownishGrey, for: .normal)
    }

}
