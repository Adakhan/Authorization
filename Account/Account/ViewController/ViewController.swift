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
import FirebaseDatabase

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, LoginButtonDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButtonOutlet: UIButton!
    @IBOutlet weak var orLabel: UILabel!

    @IBOutlet weak var loginButtonFb: FBLoginButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var switchButton: UIButton!

    
    var profileData = ProfileData()
    var fbProfileData = ProfileData()
    var checkSystem = ""
    
    var signUpOrIn: Bool = false {
        willSet {
            if newValue {
                titleLabel.text = "Sign Up"
                usernameField.isHidden = false
                loginButtonFb.isHidden = true
                googleLoginButton.isHidden = true
                enterButtonOutlet.setTitle("Registration", for: .normal)
                switchButton.setTitle("Sign In", for: .normal)
            } else {
                titleLabel.text = "Sign In"
                usernameField.isHidden = true
                loginButtonFb.isHidden = false
                googleLoginButton.isHidden = false
                enterButtonOutlet.setTitle("Enter", for: .normal)
                switchButton.setTitle("Sign Up", for: .normal)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    
    //MARK: - SETUP Funcs
    func initSetup() {
        //TEXT fields
        self.hideKeyboardWhenTappedAround()
        // FACEBOOK
        
        if AccessToken.current != nil {
            loadFBData()
        }
        loginButtonFb.delegate = self
        loginButtonFb.permissions = ["email", "public_profile"]
        //GOOGLE
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    
    func loadFBData() {
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
    
    
    @IBAction func enterButton(_ sender: Any) {
        var email = emailField.text
        var name = usernameField.text
        var password = passwordField.text
        
        if signUpOrIn {
            if (!email!.isEmpty) && (!name!.isEmpty) && (!password!.isEmpty) {
                Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            self.showRegistratedAlert()
                            email = ""
                            name = ""
                            password = ""
                        }
                    }
                }
            } else {
                self.showErrorAlert()
            }
        } else {
            if (!email!.isEmpty) && (!password!.isEmpty) {
                Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                    if error == nil {
                        self.showRegistratedAlert()
                        email = ""
                        name = ""
                        password = ""
                    }
                }
            } else {
                self.showErrorAlert()
            }
        }
        
    }
    
    @IBAction func switchButtonAction(_ sender: Any) {
        signUpOrIn = !signUpOrIn
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if signUpOrIn {
            if textField == emailField {
                textField.resignFirstResponder()
                usernameField.becomeFirstResponder()
            } else if textField == usernameField {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            } else if textField == passwordField {
                textField.resignFirstResponder()
            }
        } else {
            if textField == emailField {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            } else if textField == passwordField {
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    
    
    //MARK: - FACEBOOK Authorization
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
    {
        loadFBData()
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
