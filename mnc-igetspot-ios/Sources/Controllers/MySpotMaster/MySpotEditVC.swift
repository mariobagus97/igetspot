////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotEditVCDelegate: class {
    func saveButtonDidClicked(content:String, editVC:MySpotEditVC)
}

class MySpotEditVC: MKViewController {
    
    var mySpotEditView: MySpotEditView!
    var aboutTextString: String = ""
    private let saveButton = UIButton(type: .custom)
    private let cancelButton = UIButton(type: .custom)
    
    var delegate: MySpotEditVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSwipeMenuView()
        setupNavigationBar()
        addViews()
        setContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mySpotEditView.showKeyboard(isShow: true)
    }
    
    override func setupNavigationBar() {
        setupNavigationBarTitle(self.title ?? "")
        setupBarButtonItem()
    }
    
    @objc func saveButtonDidClicked() {
        mySpotEditView.showKeyboard(isShow: false)
        delegate?.saveButtonDidClicked(content: mySpotEditView.textView.text, editVC:self)
    }
    
    @objc func cancelButtonDidClicked() {
        mySpotEditView.showKeyboard(isShow: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupBarButtonItem() {
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        cancelButton.setTitleColor(Colors.blueTwo, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClicked), for: .touchUpInside)
        let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveButton.titleLabel?.font = R.font.barlowMedium(size: 14)
        saveButton.setTitleColor(Colors.blueTwo, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonDidClicked), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    func addViews() {
        mySpotEditView = MySpotEditView()
        view.addSubview(mySpotEditView)
        
        mySpotEditView.snp.makeConstraints{ (make) in
            make.left.right.bottom.top.equalTo(view)
        }
        
        mySpotEditView.textView.delegate = self
    }
    
    func setContent() {
        mySpotEditView.setContent(aboutString: aboutTextString)
    }

}

extension MySpotEditVC : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text, text.isEmptyOrWhitespace() == false else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.gray, for: .normal)
            return
        }
        saveButton.setTitleColor(Colors.blueTwo, for: .normal)
        saveButton.isEnabled = true
    }
}
