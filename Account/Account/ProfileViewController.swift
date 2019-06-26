//
//  ProfileViewController.swift
//  Account
//
//  Created by Adakhanau on 26/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import GoogleSignIn


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
    
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }

}
