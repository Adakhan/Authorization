//
//  Extension.swift
//  Account
//
//  Created by Adakhanau on 05/07/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Func that hide keyboard when tapp around
    //OMG, I'm fucking captain obvious. LOL
    //Func is Using by every view which has textFields
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Alerts
    func showErrorAlert() {
        let alert = UIAlertController(title: "Fields are empty!", message: "Fill in all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showRegistrationAlert() {
        let alert = UIAlertController(title: "Account Created", message: "Your account succesfully created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
 
    func showResetPasswordAlert() {
        let alert = UIAlertController(title: "Password sent", message: "Message sent. Please check your mail.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Move View to initial View
    // Part of sign out button
    func backToMainView() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as? UINavigationController
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
}
