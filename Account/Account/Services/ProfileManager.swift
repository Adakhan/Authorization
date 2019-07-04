//
//  ProfileManager.swift
//  Account
//
//  Created by Adakhanau on 04/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class ProfileManager {
    
    static let shared = ProfileManager()
    
    func profileLogout()
    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let manager = LoginManager()
        manager.logOut()
        GIDSignIn.sharedInstance().signOut()
    }
    
}
