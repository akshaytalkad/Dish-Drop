//
//  ShelterRegisterViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShelterRegisterViewController: UIViewController {

    @IBOutlet weak var programName: UITextField!
    @IBOutlet weak var shelterLat: UITextField!
    @IBOutlet weak var shelterLong: UITextField!
    @IBOutlet weak var shelterEmail: UITextField!
    @IBOutlet weak var shelterPass: UITextField!
    @IBOutlet weak var shelterConfPass: UITextField!
    
    var geoLocation : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        
        if let name = programName.text {
            
            if let lat = shelterLat.text {
                
                if let long = shelterLong.text {
                    
                    if let email = shelterEmail.text {
                        
                        if let password = shelterPass.text {
                            
                            if let confPass = shelterConfPass.text {
                                
                                geoLocation.append(Double(lat) ?? 0)
                                geoLocation.append(Double(long) ?? 0)
                                
                                Auth.auth().createUser(withEmail: email, password: password) { [self] (result, error) in
                                    
                                    if error != nil {
                                        
                                        print(error?.localizedDescription)
                                        
                                    } else {
                                        
                                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                                        request?.displayName = "shelter"
                                        request?.commitChanges(completion: nil)
                                        self.performSegue(withIdentifier: "shelter", sender: nil)
                                        
                                    }
                                    
                                }
                                
                                
                                DatabaseManager.shared.insertShelter(with: MealProgram(geolocation: geoLocation, name: name, email: email)) { (success) in
                                    
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
        
        
    }
    
    
}
