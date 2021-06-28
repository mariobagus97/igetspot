//
//  CategoryFilterView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 02/02/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit
import TTRangeSlider

protocol CategoryFilterViewDelegate:class {
    func closeFilterView()
    func categoryFilterDidApplied(parameters:[String:String]?)
}

class CategoryFilterView: UIView {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerPriceView: UIView!
    @IBOutlet weak var selectedPriceView: UIView!
    @IBOutlet weak var selectedPriceLabel: UILabel!
    @IBOutlet weak var minPriceView: UIView!
    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceView: UIView!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var priceSlider: TTRangeSlider!
    @IBOutlet weak var filterRatingView: FilterRatingView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var heightPriceViewConstraint: NSLayoutConstraint!
    var parameters = [String:String]()
    
    static let paramKeyRate = "filterByrate"
    static let paramKeyHighPrice = "filterByhighprice"
    static let paramKeylowPrice = "filterBylowprice"
    let minPrice = 0
    let maxPrice = 100000000
    let stepPrice = 100000
    
    weak var delegate: CategoryFilterViewDelegate?
    var selectedPrice = 0 {
        didSet {
            setFormattedSelectedPrice(selectedPrice)
        }
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        adjustLayout()
        setupPriceSlider()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        adjustLayout()
        setupPriceSlider()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustLayout()
        setupPriceSlider()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonDidClicked() {
        delegate?.closeFilterView()
    }
    
    @IBAction func applyButtonDidClicked() {
        delegate?.categoryFilterDidApplied(parameters: parameters)
    }
    
    // MARK: - Publics Functions
    func setupLayout(categoryPageType:CategoryPageContentType, currentParameters:[String:String]?) {
        if categoryPageType == .master {
            heightPriceViewConstraint.constant = 0
            self.layoutIfNeeded()
        }
        guard let parameters = currentParameters else {
            return
        }
        self.parameters = parameters
        if let maxPrice = parameters[CategoryFilterView.paramKeyHighPrice], let maxPriceFloat = Float(maxPrice) {
            selectedPrice = Int(maxPriceFloat)
            priceSlider.selectedMaximum = maxPriceFloat
        }
        
        if let rate = parameters[CategoryFilterView.paramKeyRate] {
            filterRatingView.setCurrentSelectedRating(currentRating: rate)
        }
        
    }
    
     // MARK: - Private Functions
    private func adjustLayout() {
        selectedPriceView.makeItRounded(width: 1, borderColor: UIColor.black.cgColor, cornerRadius: 5)
        minPriceView.makeItRounded(width: 1, borderColor: UIColor.black.cgColor, cornerRadius: 5)
        maxPriceView.makeItRounded(width: 1, borderColor: UIColor.black.cgColor, cornerRadius: 5)
        
        applyButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        applyButton.makeItRounded(width: 0, borderColor: UIColor.clear.cgColor, cornerRadius: applyButton.bounds.size.height/2)
        
        filterRatingView.delegate = self
    }
    
    private func setupPriceSlider() {
        minPriceLabel.text = "\(minPrice)".currency
        maxPriceLabel.text = "\(maxPrice)".currency
        selectedPriceLabel.text = "\(maxPrice)".currency
        priceSlider.delegate = self
        priceSlider.lineHeight = 3.0
        priceSlider.disableRange = true
        priceSlider.minValue = Float(minPrice)
        priceSlider.maxValue = Float(maxPrice)
        priceSlider.handleImage = R.image.sliderKnob()
        priceSlider.handleDiameter = 32
        priceSlider.tintColorBetweenHandles = UIColor.black
        priceSlider.hideLabels = true
        priceSlider.enableStep = true
        priceSlider.step = Float(stepPrice)
        priceSlider.selectedMinimum = Float(minPrice)
        priceSlider.selectedMaximum = Float(maxPrice)
        priceSlider.selectedHandleDiameterMultiplier = 1.3
    }
    
    private func setFormattedSelectedPrice(_ price:Int) {
        let priceString = String(price)
        selectedPriceLabel.text = "\(priceString.currency)"
    }
}

// MARK: - TTRangeSliderDelegate
extension CategoryFilterView : TTRangeSliderDelegate {
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        selectedPrice = Int(selectedMaximum)
        self.parameters[CategoryFilterView.paramKeyHighPrice] = "\(selectedPrice)"
        self.parameters[CategoryFilterView.paramKeylowPrice] = "\(0)"
        if selectedPrice == maxPrice {
            self.parameters[CategoryFilterView.paramKeyHighPrice] = nil
            self.parameters[CategoryFilterView.paramKeylowPrice] = nil
        }
    }
    
}

extension CategoryFilterView : FilterRatingViewDelegate {
    func filterRatingDidSelect(selectedRating rating: Int) {
        print("rating filter \(rating)")
        if rating == 0 {
            self.parameters[CategoryFilterView.paramKeyRate] = nil
        } else {
            self.parameters[CategoryFilterView.paramKeyRate] = "\(rating)"
        }
    }
}
