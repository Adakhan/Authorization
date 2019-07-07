//
//  ResetPasswordViewController.swift
//  Account
//
//  Created by Adakhanau on 07/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        self.hideKeyboardWhenTappedAround()
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = emailTextField.text
        if !email!.isEmpty {
            Auth.auth().sendPasswordReset(withEmail: email!) { error in
                if error == nil {
                    self.emailTextField.resignFirstResponder()
                    self.showResetPasswordAlert()
                }
            }
            
        }
        return false
    }

}
