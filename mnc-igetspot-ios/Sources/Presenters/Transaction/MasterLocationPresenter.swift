////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import UIKit

class MasterLocationPresenter: MKPresenter {
    private weak var locationView: MasterLocationVC?
    var transactionService: TransactionService?
    
    override init() {
        super.init()
        transactionService = TransactionService()
    }
    
    func attachview(_ view: MasterLocationVC) {
        self.locationView = view
    }
}
