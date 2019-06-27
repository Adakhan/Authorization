//
//  ViewController.swift
//  Account
//
//  Created by Adakhanau on 25/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, LoginButtonDelegate {
    
    
    
    let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email"]
        return button
    }()
    
    var profileData = ProfileData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(fbLoginButton)
        fbLoginButton.center = view.center
        fbLoginButton.delegate = self
        
        if let token = AccessToken.current {
            fetchProfile()
            print("TOKEN: \(token)")
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

    }
    
    func fetchProfile() {
        print("fetch profile")
        GraphRequest(graphPath: "/me", parameters: ["fields" : "email, first_name, last_name, name"], httpMethod: .get).start { (connection, result, error) in
            
            if error != nil {
                print("FETCH PROFILE ERROR: \(error!)")
                return
            }
            
            if let email = (result as AnyObject)["email"]! as? String {
                self.profileData.email = email  + " Facebook"
            }
            if let firstName = (result as AnyObject)["first_name"]! as? String {
                self.profileData.givenName = firstName
            }
            if let lastName = (result as AnyObject)["last_name"]! as? String {
                self.profileData.familyName = lastName
            }
            if let fullName = (result as AnyObject)["name"]! as? String {
                self.profileData.fullName = fullName
                self.profileData.system = "Facebook"
            }
            
            
        }
    }
    
    
    //MARK: - FACEBOOK Authorization
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("completed login")
        fetchProfile()
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
    //MARK: - Google Authorization
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
//            profileData.userId = user.userID                  // For client-side use only!
//            profileData.idToken = user.authentication.idToken // Safe to send to the server
            profileData.fullName = user.profile.name
            profileData.givenName = user.profile.givenName
            
            profileData.familyName = user.profile.familyName
            profileData.email = user.profile.email  + " Google"
            
            profileData.system = "Google"
            // ...
            performSegue(withIdentifier: "segue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let profileVC = segue.destination as! ProfileViewController
            profileVC.profileInfo = profileData
        }
    }
}
