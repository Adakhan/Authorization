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


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if profileInfo.email == nil {
            emailLabel.text = "Connection Failed. Re-connect, please."
        }
        if profileInfo.system == nil {
            topTitleLabel.text = "Oops..."
        } else {
            topTitleLabel.text = "Your \(profileInfo.system!) Profile"
        }
    }
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject)
    {
        let manager = LoginManager()
        manager.logOut()
        
        GIDSignIn.sharedInstance().signOut()
        dismiss(animated: true, completion: nil)
    }
}
