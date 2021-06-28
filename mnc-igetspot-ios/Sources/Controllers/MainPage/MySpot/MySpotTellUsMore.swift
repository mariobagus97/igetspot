//
//  MySpotTellUsMore.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 11/7/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//


import UIKit
import SwiftMessages

class MySpotTellUsMore : MKViewController {
    
    
    let mySpotTellusMore = UINib(nibName: "MySpotRegistrationTellUsMore", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MySpotRegistrationTellUsMore
    
    var imageList = [UIImage]()
    var type: Int!
    var mPresenter = MySpotTellUsMorePresenter()
    var popupSegue : CustomPopupSegue!
    
    let workList = ["One Great Year", "Three Awesome Years", "Five Amazing Years", "More Than A Decade"]
    
    var masterName: String!
    var describeWork: String!
    var workTime: String!
    var instagram: String!
    var linkedin: String!
    var youtube: String!
    var website: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        addView()
        self.mPresenter.attachview(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.presentIGSNavigationBar()
    }
    
    override func viewWillFirstAppear() {
        super.viewWillFirstAppear()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setupNavigationBarTitle(NSLocalizedString("Tell Us More About You", comment: ""))
        setupLeftBackBarButtonItems(barButtonType: .backButton)
    }
    
    override func showSignInPage(action: UIAlertAction) {
        self.navigationController?.pushViewController(SignInVC(), animated: true)
    }
    
    func addView(){
        
        self.view.addSubview(mySpotTellusMore)
        
        mySpotTellusMore.delegate = self
        
        mySpotTellusMore.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func successRegistration(){
        let whatToOffer = MySpotWhatToOfferVC()
        self.navigationController?.pushViewController(whatToOffer, animated: true)
    }
}


extension MySpotTellUsMore : MySpotRegistrationTellUsMoreDelegate {
    
    func onContinue(masterName: String, describeWork: String, workTime: String, instagram: String, linkedin: String, youtube: String, website: String) {
        self.masterName = masterName
        self.describeWork = describeWork
        self.workTime = workTime
        self.instagram = instagram
        self.linkedin = linkedin
        self.youtube = youtube
        self.website = website
        
         self.mPresenter.uploadRegistration(masterName: masterName, describeWork: describeWork, workTime: workTime, instagram: instagram, linkedin: linkedin, youtube: youtube, website: website)
    }
    
    func showTimeWorkPicker() {
        
        let view: MySpotPickerView = try! SwiftMessages.viewFromNib()
        view.configureNoDropShadow()
        view.delegate = self
        view.setContent(stringArray: self.workList)
        view.setTitle(title: NSLocalizedString("How Long?", comment: ""))
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .color(color: UIColor.black.withAlphaComponent(0.8), interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
}

extension MySpotTellUsMore: MySpotPickerViewDelegate {
    func mySpotPickerCloseButtonDidClicked() {
        SwiftMessages.hide()
    }
    
    func mySpotPickerDidSelectedCell(id: Int, name: String) {
        SwiftMessages.hide()
        mySpotTellusMore.setLongWork(time: name)
    }
}

class CustomPopupSegue: SwiftMessagesSegue {
    
    override public  init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        configure(layout: .centered)
        containerView.cornerRadius = 0
    }
    
}

