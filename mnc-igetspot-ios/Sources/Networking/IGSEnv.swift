////
//  I Get Spot
//
//  Created by Muhammad Nizar on 07/01/19.
//  Copyright © 2019 MNC Innovation Center. All rights reserved.
//

import Foundation

struct IGSEnv {
    
    private struct APIDomain {
        static let Prod = "https://api.igetspot.com"
        static let Dev = "https://stag-api.igetspot.com"
    }
    
    private struct APIStaticDomain {
        static let Prod = "https://apidashboard.igetspot.com"
        static let Dev = "https://stag-apidashboard.igetspot.com"
    }
    
    private struct Routes {
        static let Api = "/api/v1/"
    }
    
    private struct ImageAuthDomain {
        static let Prod = "https://igetspot.com"
        static let Dev = "https://stag-cdn.igetspot.com"
    }
    
    private struct ImageApiDomain {
        static let Prod = "https://api.igetspot.com"
        static let Dev = "https://stag-cdn.igetspot.com"
    }
    
    private struct ImageStaticDomain {
        static let Prod = "https://apidashboard.igetspot.com"
        static let Dev = "https://stag-cdn.igetspot.com"
    }
    
    private struct ShareDomain {
        static let Prod = "https://igetspot.com/master"
        static let Dev = "https://stag.igetspot.com/master"
    }
    
    private struct HelpCenterFAQ {
        static let Prod = "https://igetspot.com/faq"
        static let Dev = "https://stag.igetspot.com/faq"
        
    }
    
    
    // Change scheme to change base url
    #if SERVICE_CONFIG_DEVELOPMENT
    private static let Domain = APIDomain.Dev
    private static let IGSShareBaseUrl = ShareDomain.Dev
    private static let StaticDomain = APIStaticDomain.Dev
    private static let ImageAuthBaseUrl = ImageAuthDomain.Dev
    private static let ImageApiBaseUrl = ImageApiDomain.Dev
    private static let ImageApiStaticUrl = ImageStaticDomain.Dev
    private static let IGSFAQUrl = HelpCenterFAQ.Dev
    #else
    private static let Domain = APIDomain.Prod
    private static let IGSShareBaseUrl = ShareDomain.Prod
    private static let StaticDomain = APIStaticDomain.Prod
    private static let ImageAuthBaseUrl = ImageAuthDomain.Prod
    private static let ImageApiBaseUrl = ImageApiDomain.Prod
    private static let ImageApiStaticUrl = ImageStaticDomain.Prod
    private static let IGSFAQUrl = HelpCenterFAQ.Prod
    #endif
    
    static var IGetSpotBaseUrl: String {
        return Domain + Routes.Api
    }
    
    static var IGetSpotStaticBaseUrl: String {
        return StaticDomain + Routes.Api
    }
    
    static var IGSImageBaseUrl: String {
        return ImageApiBaseUrl
    }
    
    static var IGSImageAuthBaseUrl: String {
        return ImageAuthBaseUrl
    }
    
    static var IGSImageStaticBaseUrl: String {
        return ImageApiStaticUrl
    }
    
    static var IGetSpotShareUrl: String {
        return IGSShareBaseUrl
    }
    
    static var IGetSpotFAQUrl: String {
        return IGSFAQUrl
    }
    
    static var IGetSpotDomainUrl: String {
        return Domain + "/"
    }
}
