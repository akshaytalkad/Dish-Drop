//
//  SignUpViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/2/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if let firstName = firstNameTextField.text {
            
            if let lastName = lastNameTextField.text {
                
                if let email = emailTextField.text {
                    
                    if let password = passwordTextField.text {
                        
                        Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                            
                            if error != nil {
                                
                                print(error?.localizedDescription)
                                
                            } else {
                                
                                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                                request?.displayName = "driver"
                                request?.commitChanges(completion: nil)
                                self.performSegue(withIdentifier: "driver", sender: nil)
                                
                            }
                            
                            DatabaseManager.shared.insertDriver(with: Driver(firstName: firstName,
                                                                           lastName: lastName,
                                                                           email: email)) { (success) in
                                
                                if !success {
                                    print("error")
                                }
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
