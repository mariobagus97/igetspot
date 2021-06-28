//
//  SignInVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/8/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FloatingPanel
import SwiftMessages
import AuthenticationServices

protocol SignUpVCDelegate {
    func userHasSuccessfulRegister()
}

class SignUpVC: MKViewController {
    
    var signUpPresenter = SignUpPresenter()
    var signInPresenter = SignInPresenter()
    var isFromMainTabbar = false
    var delegate: SignUpVCDelegate?
    var confirmPanel : FloatingPanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpPresenter.attachview(self)
        signInPresenter.attachview(self)
        addView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            performExistingAccountSetupFlows()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func addView(){
        // load view from custom UIView (SignInComponent-xib name)
        
        let signUpView = UINib(nibName: "SignUpPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SignUpPage
        signUpView.delegate = self
        
        self.view.addSubview(signUpView)
        
        signUpView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    
    func moveVC(email: String, password: String) {
        DispatchQueue.main.async {
            self.signInPresenter.signInEmail(email: email, password: password)
        }
    }
    
    func moveVC(fromSosmed token: String, type: SocialMediaLoginType, userid: String, email: String, isLogin: Bool) {
        DispatchQueue.main.async {
            self.signInPresenter.signInSosmed(token: token, type: type, userid: userid, email: email, isLogin: isLogin)
        }
    }
    
    func showConfirmPage() {
        confirmPanel = FloatingPanelController()
        
        // Initialize FloatingPanelController and add the view
        confirmPanel?.surfaceView.cornerRadius = 8.0
        confirmPanel?.surfaceView.shadowHidden = false
        confirmPanel?.isRemovalInteractionEnabled = false
        confirmPanel?.delegate = self
        
        let confirmVC = SignUpConfirmVC()
        confirmVC.delegate = self
        
        confirmPanel?.set(contentViewController: confirmVC)
        self.present(confirmPanel!, animated: true, completion: nil)
    }
    
    private func hideConfirmPage() {
        if let confirmPanel = self.confirmPanel {
            confirmPanel.dismiss(animated: true, completion: nil)
            if self.isFromMainTabbar == true {
                self.delegate?.userHasSuccessfulRegister()
            } else {
                self.setRootHomePage()
            }
        }
    }
    
    func moveToEditVC(){
        let editProfile = ProfileTVC()
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
    
    func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // - Tag: perform_appleid_password_request
    @available(iOS 13.0, *)
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension SignUpVC: SignUpProtocol{
    func signUp(email: String, password: String) {
        
        signUpPresenter.signUpEmail(email: email, password: password)
        
    }
    
    func signInFacebook() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if (error != nil){
                self.showErrorMessageBanner(error!.localizedDescription)
                
            } else if (result?.isCancelled)!{
            } else if (result?.declinedPermissions.contains("email"))!{
                self.showErrorMessageBanner(StringConstants.FacebookError.noEmailMessage)
            } else {
                let fbToken = result?.token?.tokenString
                let req = GraphRequest(graphPath: "me", parameters: ["fields":"email, id"], tokenString: fbToken, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
                
                _ = req.start(completionHandler: { (connection, result, error) -> Void in
                    if(error == nil) {
                        if let responseDict = result as? [String : AnyObject] {
                            if (responseDict["email"] == nil) {
                                self.showErrorMessageBanner(StringConstants.FacebookError.noEmailMessage)
                            } else {
                                guard let token = fbToken, let email = responseDict["email"] as? String, let userId = responseDict["id"] as? String  else {
                                    return
                                }
                                self.signUpPresenter.signInSosmed(token: token, type: .facebook, userid: userId, email: email, isLogin: true)                            }
                        }
                    } else {
                        self.showErrorMessageBanner(StringConstants.MessageErrorAPI.tryAgainMessage)
                    }
                })
            }
        }
    }
    
    func signInGoogle() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signInApple() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func exploreAppPressed() {
        if isFromMainTabbar {
            dismiss(animated: true, completion: nil)
        } else {
            setRootHomePage()
        }
        
    }
    
    func onPolicyPressed(){
        self.navigationController?.pushViewController(PrivacyPolicyVC(), animated: true)
    }
    
    func onUserAgreementPressed() {
        self.navigationController?.pushViewController(UserAgreementVC(), animated: true)
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK : - GIDSignInDelegate
extension SignUpVC : GIDSignInDelegate {
    // MARK : - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // For client-side use only!
            if let token = user.authentication.idToken, let email = user.profile.email, let userId =  user.userID {
                signUpPresenter.signInSosmed(token: token, type: .google, userid: userId, email: email, isLogin: true)
            }
        } else {
            #if DEBUG_SERVICE_MODE
            print("didSignInForUser error :\(error.localizedDescription)")
            #endif
            if (error.localizedDescription.contains("The user canceled the sign-in flow")) {
                print("didSignInForUser user cancel")
            } else {
                self.showErrorMessageBanner(error.localizedDescription)
            }
        }
    }
}


@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        var userIdentifier = ""
        var fullName = ""
        var email = ""
        var username = ""
        var password = ""
        var token = ""
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            userIdentifier = appleIDCredential.user
            let fName = appleIDCredential.fullName?.givenName ?? ""
            let lName = appleIDCredential.fullName?.familyName ?? ""
            fullName = fName + lName
            email = appleIDCredential.email ?? ""
            token = appleIDCredential.identityToken?.toHexString() ?? ""
            
            //manage credential here
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            username = passwordCredential.user
            password = passwordCredential.password
            
            
        default:
            break
        }
        
        if token != "" && email != "" && userIdentifier != "" {
            signUpPresenter.signInSosmed(token: token, type: .apple, userid: userIdentifier, email: email, isLogin: true)
        }
        else {
            self.showErrorMessageBanner(StringConstants.MessageErrorAPI.tryAgainMessage)
        }
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SignUpVC: FloatingPanelControllerDelegate {
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        if self.isFromMainTabbar == true {
            self.delegate?.userHasSuccessfulRegister()
        } else {
            self.setRootHomePage()
        }
    }
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FullPanelLayout()
    }
    
}

extension SignUpVC : SignUpConfirmVCDelegate {
    func hideConfirmVCPanel() {
        hideConfirmPage()
    }
}

extension SignUpVC : SignUpView {
    func showLoading() {
        showLoadingHUD()
    }
    
    func hideLoading() {
        hideLoadingHUD()
    }
    
    func showErrorMessage(_ message: String) {
        showErrorMessageBanner(message)
    }
    
}

extension SignUpVC : SignInView {
    func moveVC() {
        UserProfileManager.shared.requestProfileUser(completion: { [weak self] (success) in
            self?.hideLoadingHUD()
            if success {
                self?.showConfirmPage()
            } else {
                self?.showErrorMessageBanner(StringConstants.MessageErrorAPI.tryAgainMessage)
            }
        })
    }
}
