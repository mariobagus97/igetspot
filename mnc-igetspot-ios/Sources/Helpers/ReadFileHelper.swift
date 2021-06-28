////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

class ReadFileHelper {
    class func readHTMLFileFromBundle(fileName:String) -> String? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "html") {
            let htmlString = try? String(contentsOfFile: path)
            return htmlString
        } else {
            print("Invalid filename/path.")
        }
        
        return nil
    }
}
