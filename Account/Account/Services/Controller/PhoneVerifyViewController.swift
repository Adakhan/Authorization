//
//  PhoneAuthViewController.swift
//  Account
//
//  Created by Adakhanau on 08/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneVerifyViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var numberField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        numberField.becomeFirstResponder()
    }
    
    
    @IBAction func sendCodeButton(_ sender: Any) {
        let number = numberField.text
        let defaults = UserDefaults.standard
        let alert = UIAlertController(title: "Phone number", message: "Is this your phone number? \n \(number!)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(number!, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    print("eror: \(String(describing: error?.localizedDescription))")
                } else {
                    defaults.set(verificationID, forKey: "authVID")
                    self.numberField.text = ""
                    self.performSegue(withIdentifier: "login", sender: Any?.self)
                }
            }
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
