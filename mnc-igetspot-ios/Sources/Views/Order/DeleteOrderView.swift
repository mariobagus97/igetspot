//
//  DeleteOrderView.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 04/04/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

protocol DeleteOrderViewDelegate:class {
    func deleteAndSaveFavoriteButtonDidClicked()
    func deleteButtonDidClicked()
}


class DeleteOrderView: UIView {

    @IBOutlet weak var deleteAndSaveFavoriteButton: UIButton!
    @IBOutlet weak var deleteButton: GradientBorderButton!
    weak var delegate: DeleteOrderViewDelegate?
    
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
        deleteAndSaveFavoriteButton.makeItRounded(width:0.0, cornerRadius : deleteAndSaveFavoriteButton.bounds.height / 2)
        deleteAndSaveFavoriteButton.applyGradient(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], xStartPos: 0, xEndPos: 1, yStartPos: 0, yEndPos: 0)
        
        deleteButton.setTitleColor(Colors.vividBlue, for: .normal)
        deleteButton.setupButton(colors: [Colors.gradientThemeTwo, Colors.gradientThemeOne], startPoint: CGPoint.zero, endPoint: CGPoint(x: 1, y: 0), cornerRadius: deleteButton.bounds.height)
    }
    
    // MARK: - Actions
    @IBAction func deleteAndSaveFavoriteButtonDidClicked() {
        delegate?.deleteAndSaveFavoriteButtonDidClicked()
    }
    
    @IBAction func deleteButtonDidClicked() {
        delegate?.deleteButtonDidClicked()
    }

}
