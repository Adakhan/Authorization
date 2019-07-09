//
//  PhoneLogInViewController.swift
//  Account
//
//  Created by Adakhanau on 09/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneLogInViewController: UIViewController {

    
    @IBOutlet weak var codeField: UITextField!
    
    var phoneProfile = ProfileData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeField.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
    }
    

    @IBAction func loginButton(_ sender: Any)
    {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: codeField.text!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                let userInfo = user?.user.providerData[0]
                print("Provider ID: \(String(describing: userInfo?.providerID))")
                self.phoneProfile.system = "Phone"
                self.phoneProfile.email = "There is no full information. "
                self.phoneProfile.fullName = "Because, you signed in with phone number."
                self.phoneProfile.givenName = "That's why here is only your phone number:"
                self.phoneProfile.familyName = user?.user.phoneNumber
                self.performSegue(withIdentifier: "logged", sender: Any?.self)
            }
        }
        
    }
    
    //MARK: - Transfer data to ProfileVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logged" {
            let nav = segue.destination as! UINavigationController
            let profileVC = nav.topViewController as! ProfileViewController
            profileVC.profileInfo = phoneProfile
        }
    }

}
