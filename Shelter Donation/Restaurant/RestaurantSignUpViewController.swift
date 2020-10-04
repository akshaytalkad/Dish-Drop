//
//  RestaurantSignUpViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RestaurantSignUpViewController: UIViewController {

    @IBOutlet weak var restName: UITextField!
    @IBOutlet weak var restLat: UITextField!
    @IBOutlet weak var restLong: UITextField!
    
    @IBOutlet weak var restEmail: UITextField!
    @IBOutlet weak var restPass: UITextField!
    @IBOutlet weak var restConfPass: UITextField!
    
    var geoLocation: [Double] = []
    
    @IBAction func registerPressed(_ sender: Any) {
        
        if let name = restName.text {
            
            if let lat = restLat.text {
                
                if let long = restLong.text {
                    
                    if let email = restEmail.text {
                        
                        if let password = restPass.text {
                            
                            if let confirmPass = restConfPass.text {
                                
                                geoLocation.append(Double(lat) ?? 0)
                                geoLocation.append(Double(long) ?? 0)
                                
                                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                                    
                                    if error != nil {
                                        
                                        print("error")
                                        print(error?.localizedDescription)
                                        
                                    } else {
                                        
                                        let request = Auth.auth().currentUser?.createProfileChangeRequest()
                                        request?.displayName = "restaurant"
                                        request?.commitChanges(completion: nil)
                                        self.performSegue(withIdentifier: "restaurant", sender: nil)
                                    }
                                    
                                }
                                
                                DatabaseManager.shared.insertRestaurant(with: Restaurant(geolocation: geoLocation, name: name, mealsProvided: 0, email: email)) { (success) in
                                    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
