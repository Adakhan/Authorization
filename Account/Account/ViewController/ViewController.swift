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

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var orLabel: UILabel!

    @IBOutlet weak var customFBButtonOutlet: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var switchButton: UIButton!

    @IBOutlet weak var resetButtonOutlet: UIButton!
    
    var gProfileData = ProfileData()
    var fbProfileData = ProfileData()
    var fireProfileData = ProfileData()
    var checkSystem = ""
    
    var signUpOrIn: Bool = false {
        willSet {
            if newValue {
                self.title = "Sign Up"
                firstNameField.isHidden = false
                lastNameField.isHidden = false
                customFBButtonOutlet.isHidden = true
                googleLoginButton.isHidden = true
                switchButton.setTitle("Sign In", for: .normal)
                resetButtonOutlet.isHidden = true
            } else {
                self.title = "Sign In"
                firstNameField.isHidden = true
                lastNameField.isHidden = true
                customFBButtonOutlet.isHidden = false
                googleLoginButton.isHidden = false
                switchButton.setTitle("Sign Up", for: .normal)
                resetButtonOutlet.isHidden = false
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    
    
    //MARK: - SETUP Funcs
    func initSetup() {
        //TEXT fields
        self.hideKeyboardWhenTappedAround()
        // FACEBOOK
        if AccessToken.current != nil {
            loadFBData()
        }
        //GOOGLE
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    
    
    @IBAction func fbButton(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            self.loadFBData()
            self.checkSystem = "fb"
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error)
                    return
                }
                // User is signed in
            }
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    

    
    @IBAction func switchButtonAction(_ sender: Any) {
        signUpOrIn = !signUpOrIn
    }
    
    //MARK: - Transfer data to ProfileVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let profileVC = segue.destination as! ProfileViewController
            if checkSystem == "fb" {
                profileVC.profileInfo = fbProfileData
            } else if checkSystem == "g" {
                profileVC.profileInfo = gProfileData
            } else {
                profileVC.profileInfo = fireProfileData
            }
        }
    }
    
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailField.text
        let firstName = firstNameField.text
        
        let lastName = lastNameField.text
        let password = passwordField.text
        let fullName = "\(firstName!) \(lastName!)"
        
        let ref = Database.database().reference().child("users")
        
        if signUpOrIn {
            if textField == emailField {
                textField.resignFirstResponder()
                firstNameField.becomeFirstResponder()
            } else if textField == firstNameField {
                textField.resignFirstResponder()
                lastNameField.becomeFirstResponder()
            } else if textField == lastNameField {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            } else if textField == passwordField {
                textField.resignFirstResponder()
                if (!email!.isEmpty) && (!firstName!.isEmpty) && (!lastName!.isEmpty) && (!password!.isEmpty) {
                    Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                        if error == nil {
                            if let result = result {
                                ref.child(result.user.uid).updateChildValues(["email" : email!,"full_name" : fullName,"first_name" : firstName!, "last_name" : lastName!])
                                self.showRegistratedAlert()
                            }
                        }
                    }
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if error == nil {
                            self.showVerificationAlert()
                        }
                    }
                } else {
                    self.showErrorAlert()
                }
            }
        } else {
            if textField == emailField {
                textField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            } else if textField == passwordField {
                textField.resignFirstResponder()
                if (!email!.isEmpty) && (!password!.isEmpty) {
                    Auth.auth().signIn(withEmail: email!, password: password!) { (result, error) in
                        if error == nil {
                            if let user = Auth.auth().currentUser {
                                ref.child((result?.user.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                                    if !snapshot.exists() { return }
                                    
                                    self.fireProfileData.email = user.email
                                    self.fireProfileData.fullName = snapshot.childSnapshot(forPath: "full_name").value as? String
                                    self.fireProfileData.givenName = snapshot.childSnapshot(forPath: "first_name").value as? String
                                    self.fireProfileData.familyName = snapshot.childSnapshot(forPath: "last_name").value as? String
                                    
                                    self.fireProfileData.system = "Firebase"
                                    self.checkSystem = "Firebase"
                                    self.performSegue(withIdentifier: "segue", sender: self)
                                })
                            }
                        }
                    }
                } else {
                    self.showErrorAlert()
                }
            }
        }
        return true
    }
    
}


//MARK: - GOOGLE Authorization
extension ViewController: GIDSignInUIDelegate, GIDSignInDelegate{
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!)
    {
        if (error != nil) {
            print("google error \(error.localizedDescription)")
        } else {
            // if here is no error
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
            gProfileData.fullName = user.profile.name
            gProfileData.givenName = user.profile.givenName
            
            gProfileData.familyName = user.profile.familyName
            gProfileData.email = user.profile.email
            
            gProfileData.system = "Google"
            checkSystem = "g"
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
}


//MARK: - FACEBOOK Authorization
extension ViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?)
    {
    //
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //
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
}
