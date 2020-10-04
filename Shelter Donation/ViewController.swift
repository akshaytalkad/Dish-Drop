//
//  ViewController.swift
//  Shelter Donation
//
//  Created by Siddharth on 10/2/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func errorMessage(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if let username = usernameTextField.text {
            
            if let password = passwordTextField.text {
                
                Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
                    
                    if error != nil {
                        
                        self.errorMessage(title: "Login Error", message: error!.localizedDescription)
    
                    } else {
                        
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

