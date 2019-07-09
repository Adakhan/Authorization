//
//  ProfileViewController.swift
//  Account
//
//  Created by Adakhanau on 26/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth


class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    
    
    var profileInfo = ProfileData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = profileInfo.email
        fullNameLabel.text = profileInfo.fullName
        familyNameLabel.text = profileInfo.familyName
        givenNameLabel.text = profileInfo.givenName
    }
    
    
    // Func checks connection
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if profileInfo.system == nil {
            self.title = "Oops..."
            emailLabel.text = "Connection Failed. Re-connect, please."
        } else {
            self.title = "Your \(profileInfo.system!) Profile"
        }
    }
    
    //Sign out button
    //Will sign out from all authorizations
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        ProfileManager.shared.profileLogout()
        self.backToMainView()
    }
    
}
