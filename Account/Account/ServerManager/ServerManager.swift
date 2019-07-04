//
//  ServerManager.swift
//  Account
//
//  Created by Adakhanau on 28/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit


class ServerManager {
    
    static let shared = ServerManager()
    
    func fetchProfile( completion: @escaping (GraphRequestConnection?, Any?, Error?) -> Void ) {
        GraphRequest(graphPath: "/me", parameters: ["fields" : "email, first_name, last_name, name"], httpMethod: .get).start { (connection, result, error) in
            
            DispatchQueue.main.async {
                completion(connection, result, error)
            }
        }
    }
    
}
