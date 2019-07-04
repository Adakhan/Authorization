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
import FirebaseAuth

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, LoginButtonDelegate {
    
    
    @IBOutlet weak var loginButtonFb: FBLoginButton!
    
    var profileData = ProfileData()
    var fbProfileData = ProfileData()
    var checkSystem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSetUp()
        googleSetUp()
    }
    
    
    //MARK: - SETUP Funcs
    func googleSetUp() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    func FBSetUp() {
        if AccessToken.current != nil {
            loadData()
        }
        loginButtonFb.delegate = self
        loginButtonFb.permissions = ["email", "public_profile"]
    }
    
    func loadData() {
        ServerManager.shared.fetchProfile(completion: transferFBData)
    }
    
    func transferFBData(connection:GraphRequestConnection?, result: Any?, error:Error?) {
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
    
    
    //MARK: - FACEBOOK Authorization
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
    {
        loadData()
        checkSystem = "fb"
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            // User is signed in
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
    }
    
    
    //MARK: - GOOGLE Authorization
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!)
    {
        if (error == nil) {
            // Perform any operations on signed in user here.
        } else {
            print("google error \(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            // User is signed in
        }
        
        if let error = error {
            print("google error \(error.localizedDescription)")
        } else {
            profileData.fullName = user.profile.name
            profileData.givenName = user.profile.givenName
            
            profileData.familyName = user.profile.familyName
            profileData.email = user.profile.email
            
            profileData.system = "Google"
            checkSystem = "g"
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    //MARK: - Transfer data to ProfileVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let profileVC = segue.destination as! ProfileViewController
            if checkSystem == "fb" {
                profileVC.profileInfo = fbProfileData
            } else {
                profileVC.profileInfo = profileData
            }
        }
    }
    
}
