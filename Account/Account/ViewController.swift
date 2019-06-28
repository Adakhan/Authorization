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
    
    

    @IBOutlet weak var loginButtonFb: FBLoginButton!
    
    var profileData = ProfileData()
    var fbProfileData = ProfileData()
    var check = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonFb.delegate = self
        loginButtonFb.permissions = ["email"]
        
        if AccessToken.current != nil {
            fetchProfile()
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
    
    func fetchProfile() {
        print("fetch profile")
        GraphRequest(graphPath: "/me", parameters: ["fields" : "email, first_name, last_name, name"], httpMethod: .get).start { (connection, result, error) in
            
            if error != nil {
                print("FETCH PROFILE ERROR: \(error!)")
                return
            }
            if let email = (result as AnyObject)["email"]! as? String {
                self.fbProfileData.email = email
            }
            if let firstName = (result as AnyObject)["first_name"]! as? String {
                self.fbProfileData.givenName = firstName
            }
            if let lastName = (result as AnyObject)["last_name"]! as? String {
                self.fbProfileData.familyName = lastName
            }
            if let fullName = (result as AnyObject)["name"]! as? String {
                self.fbProfileData.fullName = fullName
                self.fbProfileData.system = "Facebook"
            }
        }
    }
    
    
    //MARK: - FACEBOOK Authorization
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("completed login")
        fetchProfile()
        check = "fb"
        if fbProfileData.system == nil {
            print("Don't get data ;( ")
        } else {
            print("Data fetched")
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged Out")
    }
    
    
    //MARK: - Google Authorization
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
        } else {
            print("google error \(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("google error \(error.localizedDescription)")
        } else {
            profileData.fullName = user.profile.name
            profileData.givenName = user.profile.givenName
            
            profileData.familyName = user.profile.familyName
            profileData.email = user.profile.email
            
            profileData.system = "Google"
            check = "g"
            
            performSegue(withIdentifier: "segue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let profileVC = segue.destination as! ProfileViewController
            if check == "fb" {
                profileVC.profileInfo = fbProfileData
            } else {
                profileVC.profileInfo = profileData
            }
        }
    }
}
