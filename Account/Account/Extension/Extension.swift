//
//  Extension.swift
//  Account
//
//  Created by Adakhanau on 05/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Fields are empty!", message: "Fill in all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showRegistratedAlert() {
        let alert = UIAlertController(title: "Account Created", message: "Your account succesfully created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
 
    func showResetPasswordAlert() {
        let alert = UIAlertController(title: "Password sent", message: "Email sent. Please check your mail.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
