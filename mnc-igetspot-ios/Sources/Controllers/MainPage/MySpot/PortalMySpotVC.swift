////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class PortalMySpotVC: MKViewController {
    
    var emptyLoadingView: EmptyLoadingView = {
        let emptyLoadingView = EmptyLoadingView()
        return emptyLoadingView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavigationBar()
        checkSession()
    }
    
    func addViews() {
        view.addSubview(emptyLoadingView)
        emptyLoadingView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        emptyLoadingView.showLoadingView()
    }
    
    func checkSession() {
        if (TokenManager.shared.isLogin()) {
            if let user = UserProfileManager.shared.getUser() {
                if (user.isMaster) {
                    let mySpotMasterDetailVC = MySpotMasterDetailVC()
                    self.navigationController?.pushViewController(mySpotMasterDetailVC, animated: false)
                    return
                }
            }
        }
        let myspotIntroVC = MySpotIntroVC()
        self.navigationController?.pushViewController(myspotIntroVC, animated: false)
    }

}
