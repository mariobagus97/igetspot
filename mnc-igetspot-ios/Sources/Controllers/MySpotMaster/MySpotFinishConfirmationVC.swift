////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

protocol MySpotFinishConfirmationVCDelegate:class {
    func backToOrderButtonDidClicked()
}

class MySpotFinishConfirmationVC: MKViewController {
    
    var headerView: FloatingPanelHeaderView!
    var finishConfirmationView: MySpotFinishConfirmationView!
    weak var delegate: MySpotFinishConfirmationVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }
    
    // MARK: - Private Funtions
    private func addViews() {
        headerView = FloatingPanelHeaderView()
        headerView.delegate = self
        headerView.titleLabel.text = NSLocalizedString("Finish Confirmation", comment: "")
        headerView.setIconTitle()
        view.addSubview(headerView)
        
        finishConfirmationView = MySpotFinishConfirmationView()
        finishConfirmationView.delegate = self
        view.addSubview(finishConfirmationView)
        
        headerView.snp.makeConstraints{ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        finishConfirmationView.snp.makeConstraints{ (make) in
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo((headerView?.snp.bottom)!).offset(0)
        }
    }
}

// MARK: - FloatingPanelHeaderViewDelegate
extension MySpotFinishConfirmationVC: FloatingPanelHeaderViewDelegate {
    func panelHeaderCloseButtonDidClicked() {
        delegate?.backToOrderButtonDidClicked()
    }
}


// MARK: - MySpotFinishConfirmationViewDelegate
extension MySpotFinishConfirmationVC: MySpotFinishConfirmationViewDelegate {
    func backToOrderButtonDidClicked() {
        delegate?.backToOrderButtonDidClicked()
    }
}
