////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit
import SnapKit

class IGSSearchBarContainerView: UIView {
    
    let searchBar: UISearchBar
    
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
        setupSearchBar()
    }
    
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
    
    func setupSearchBar() {
        searchBar.backgroundColor = .clear
        changeBackgroundColor(color: UIColor.rgb(red: 207, green: 216, blue: 220))
//        searchBar.frame.size.height = 20
//        setNeedsLayout()
//        layoutIfNeeded()
    }
    
    func changeBackgroundColor(color: UIColor) {
        // change textfield background color on searchbar
         if #available(iOS 13.0, *) {
             searchBar.searchTextField.backgroundColor = color
         } else {
            let searchTextField = searchBar.value(forKey: "_searchField") as? UITextField
            searchTextField?.backgroundColor = color
        }
        
        // remove black background color
        for subView in searchBar.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    let imageView = view as! UIImageView
                    imageView.removeFromSuperview()
                }
//                if let textField = view as? UITextField {
//                    var bounds: CGRect
//                    bounds = textField.frame
//                    bounds.size.height = 20 //(set your height)
//                    textField.bounds = bounds
//                    textField.borderStyle = UITextField.BorderStyle.roundedRect
//                }
            }
        }
    }

}
