////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotMasterInfoViewDelegate:class {
    func leftViewDidTapped()
    func rightViewDidTapped()
}

class MySpotMasterInfoView: UIView {
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var widthRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthLeftButtonConstraint: NSLayoutConstraint!
    
    var delegate: MySpotMasterInfoViewDelegate?

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupTapGestureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupTapGestureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTapGestureView()
    }
    
    // MARK: - Private Functions
    private func setupTapGestureView() {
        let leftTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(leftViewDidTapped))
        leftTapGesture.cancelsTouchesInView = false
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(leftTapGesture)
        
        let rightTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightViewDidTapped))
        rightTapGesture.cancelsTouchesInView = false
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(rightTapGesture)
    }

    // MARK: - Actions
    @objc func leftViewDidTapped() {
        delegate?.leftViewDidTapped()
    }
    
    @objc func rightViewDidTapped() {
        delegate?.rightViewDidTapped()
    }
    
    // MARK: - Public Functions
    func setupTitleLabel(leftTitle:String?, rightTitle:String?) {
        rightTitleLabel.text = rightTitle
        leftTitleLabel.text = leftTitle
    }
    
    func setupValueLabele(leftValue:String?, rightValue:String?) {
        rightValueLabel.text = rightValue
        leftValueLabel.text = leftValue
    }
    
    func hideRightButton() {
        widthRightButtonConstraint.constant = 0
        self.layoutIfNeeded()
    }
    
    func hideLeftButton() {
        widthLeftButtonConstraint.constant = 0
        self.layoutIfNeeded()
    }
}
