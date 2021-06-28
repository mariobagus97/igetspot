////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

protocol MySpotSuccessRegistrationVCDelegate {
    func redirectToManageMySpotPage()
    func redirectToManageOfficialSpotPage()
}

class MySpotSuccessRegistrationVC : MKViewController {
    
    var delegate: MySpotSuccessRegistrationVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBar()
    }
    
    func addViews() {
        let mySpotThanksPage = MySpotThanksPage()
        mySpotThanksPage.delegate = self
        self.view.addSubview(mySpotThanksPage)
        
        mySpotThanksPage.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }

}

extension MySpotSuccessRegistrationVC: MySpotThanksPageDelegate {
    func manageMySpotButtonDidClicked() {
        delegate?.redirectToManageMySpotPage()
    }
    
    func manageOfficialSpotButtonDidClicked() {
        delegate?.redirectToManageOfficialSpotPage()
    }
    
    
}
