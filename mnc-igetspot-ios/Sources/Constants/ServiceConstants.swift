////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

struct ServiceConstants {
    
    struct ContentType {
        static let applicationJSON = "application/json"
    }
    
    struct URL {
        
        
        struct Path {
            // image
            static let apiAuthImage = "/api/auth/image/"
            static let apiImage = "/api/image"
            static let apiBlogImage = "/api/image/blog"
            static let apiServiceImage = "/api/image/services"
            
            
            // user
            static let userLogin = "user/login"
            static let userRegister = "user/register"
            static let socialMediaLogin = "social-media/login"
            static let socialMediaRegister = "social-media/register"
            static let userProfile = "user/details/{uuid}"
            
        }
    }
    
    struct FieldName {
        
    }
    
    struct HTTPHeader {
        static let authorization = "Authorization"
        
    }
    
    struct HTTPResponseCode {
        static let unAuthorization = 401
        static let success = 200
        static let internalServerError = 500
    }
}
