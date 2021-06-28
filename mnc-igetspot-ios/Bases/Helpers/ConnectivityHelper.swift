//
//  ConnectivityHelper.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 16/08/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
