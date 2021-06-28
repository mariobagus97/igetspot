//
//  URLExtension.swift
//  mnc-igetspot-ios
//
//  Created by destanti on 27/05/19.
//  Copyright © 2019 InnoCent Bandung. All rights reserved.
//

import Foundation

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
