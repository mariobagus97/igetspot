//
//  WalkthroughVC.swift
//  mnc-igetspot-ios
//
//  Created by Muhammad Nizar on 19/01/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import UIKit

class WalkthroughVC: MKViewController {

    var walkthroughView: WalkthroughView = {
        let walkthroughView = WalkthroughView()
        return walkthroughView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        view.addSubview(walkthroughView)
        walkthroughView.snp.makeConstraints{ (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide.length)
        }
        let walkthroughArray = buildWalkthrough()
        walkthroughView.setupWalkthrough(withWalkthroughs: walkthroughArray)
        walkthroughView.delegate = self
       
    }
    
    private func buildWalkthrough() -> [Walkthrough] {
        let walkthrough1 = Walkthrough(title: NSLocalizedString("On the tip of your finger", comment: ""), description: NSLocalizedString("Discover all the creative services you need, from make-up artist, handcrafter, to food artisan", comment: ""), image: R.image.walkthrough1())
        let walkthrough2 = Walkthrough(title: NSLocalizedString("Hello, is it me you’re looking for?", comment: ""), description: NSLocalizedString("Chat with Spot Masters to further discuss about your deals", comment: ""), image: R.image.walkthrough2())
        let walkthrough3 = Walkthrough(title: NSLocalizedString("Safety first", comment: ""), description: NSLocalizedString("Negotiations, payment, tracking progress, to rating—everything can be securely done in one app", comment: ""), image: R.image.walkthrough3())
        let walkthrough4 = Walkthrough(title: NSLocalizedString("Time to shine", comment: ""), description: NSLocalizedString("Here, no talent is wasted. Everyone can join as Spot Master and get their talent exposed", comment: ""), image: R.image.walkthrough4())
        
        let walkthroughArray:[Walkthrough] = [walkthrough1, walkthrough2, walkthrough3, walkthrough4]
        return walkthroughArray
    }
    
    private func goToSignInVC() {
        Preference.setBool(key: PreferenceKeyConstants.skipIntroduction, value: true)
        let signInVC = SignInVC()
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
}

extension WalkthroughVC : WalkthroughViewDelegate {
    func skipButtonDidClicked() {
        goToSignInVC()
        
    }
    
    func walkthroughDidfinished() {
        goToSignInVC()
    }
}
