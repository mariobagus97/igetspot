//
//  SignInVC.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire
import SwiftyJSON
import SnapKit
import GoogleSignIn
import AuthenticationServices

enum SocialMediaLoginType: Int {
    case facebook = 1
    case google = 2
    case apple = 3
}

protocol SignInVCDelegate {
    func userHasSuccessfulLoginRegister(afterLoginScreenType:AfterLoginScreenType, afterLoginParameter:[String:String]?)
}

class SignInVC: MKViewController {
    
    var signInPresenter = SignInPresenter()
    let signInView = UINib(nibName: "SignInPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SignInPage
    var isFromMainTabbar = false
    var afterLoginScreenType:AfterLoginScreenType = .none
    var afterLoginParameter:[String:String]? = nil
    var delegate: SignInVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        signInPresenter.attachview(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavigationBar()
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
        
        signInView.delegate = self
        self.view.addSubview(signInView)
        
        signInView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self.view)
        }
        if (isFromMainTabbar) {
            signInView.showSkipButton(isHide: true)
            signInView.showCloseButton(isHide: false)
        } else {
            signInView.showSkipButton(isHide: false)
            signInView.showCloseButton(isHide: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SignInVC: SignInProtocol {
    func onForgetPressed() {
        self.navigationController?.pushViewController(ForgetPasswordVC(), animated: true)
    }
    
    func skip() {
        setRootHomePage()
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
                                self.signInPresenter.signInSosmed(token: token, type: .facebook, userid: userId, email: email, isLogin: true)                            }
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
    
    func signInEmail(email: String, password: String) {
        signInPresenter.signInEmail(email: email, password: password)
    }
    
    func signUp() {
        let signup = SignUpVC()
        signup.isFromMainTabbar = isFromMainTabbar
        signup.delegate = self
        self.navigationController?.pushViewController(signup, animated: true)
    }
    
    func closeButtonPressed() {
         self.dismiss(animated: true, completion: nil)
    }
    
    func handleSuccessfulLogin() {
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.showSuccessMessageBanner(NSLocalizedString("Login successful", comment: ""))
                self.delegate?.userHasSuccessfulLoginRegister(afterLoginScreenType: self.afterLoginScreenType , afterLoginParameter: self.afterLoginParameter)
            }
        })
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

// MARK : - GIDSignInDelegate
extension SignInVC : GIDSignInDelegate {
    // MARK : - GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // For client-side use only!
            if let token = user.authentication.idToken, let email = user.profile.email, let userId =  user.userID {
                signInPresenter.signInSosmed(token: token, type: .google, userid: userId, email: email, isLogin: true)
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

extension SignInVC: SignUpVCDelegate {
    func userHasSuccessfulRegister() {
        handleSuccessfulLogin()
    }
}

extension SignInVC : SignInView {
    func showLoading(){
        showLoadingHUD()
    }
    
    func hideLoading(){
        hideLoadingHUD()
    }
    
    func moveVC() {
        showLoadingHUD()
        UserProfileManager.shared.requestProfileUser(completion: { [weak self] (success) in
            self?.hideLoadingHUD()
            if success {
                if self?.isFromMainTabbar == true {
                    self?.handleSuccessfulLogin()
                } else {
                    self?.setRootHomePage()
                }
            } else {
                self?.showErrorMessageBanner(StringConstants.MessageErrorAPI.tryAgainMessage)
            }
        })
    }
    
    
    func showErrorMessage(_ message: String){
        showErrorMessageBanner(message)
    }
}

@available(iOS 13.0, *)
extension SignInVC: ASAuthorizationControllerDelegate {
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
            signInPresenter.signInSosmed(token: token, type: .apple, userid: userIdentifier, email: email, isLogin: true)
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
extension SignInVC: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
