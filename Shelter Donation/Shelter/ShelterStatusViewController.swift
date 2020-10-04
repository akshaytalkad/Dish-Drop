//
//  ShelterStatusViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShelterStatusViewController: UIViewController {

    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var driverName: UILabel!
    
    @IBOutlet weak var pickedUpLabel: UILabel!
    @IBOutlet weak var deliveredLabel: UILabel!
        
    @IBAction func foodReceivedPressed(_ sender: Any) {
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let shelterName = value?["name"] as? String {
                
                Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "shelterName").queryEqual(toValue: shelterName).observe(.value) { (snapshot) in
                    
                    snapshot.ref.removeValue()
                    Database.database().reference().child("Transit-Orders").removeAllObservers()
                    
                }
                
            }
            
        }
        
    }
    
    var email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let shelterName = value?["name"] as? String {
                
                print(shelterName)
                
                Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "shelterName").queryEqual(toValue: shelterName).observe(.value) { (snapshot) in
                    
                    let transitValue = snapshot.value as? NSDictionary
                    
                    var uid = ""
                    
                    for snap in snapshot.children {
                        
                        let userSnap = snap as! DataSnapshot
                        
                        uid = userSnap.key
                        
                    }
                    
                    if let dict = transitValue?["\(uid)"] as? [String:Any] {
                        
                        if let driverStatus = dict["driverStatus"] as? String {
                            
                            if let driverName = dict["driverName"] as? String {
                                
                                if let restaurantName = dict["chosenRest"] as? String {
                                    
                                    self.driverName.text = driverName
                                    
                                    self.restaurantName.text = restaurantName
                                    
                                    if driverStatus == "Picked Up" {
                                        
                                        self.pickedUpLabel.text = "Yes"
                                        
                                    } else {
                                        
                                        self.pickedUpLabel.text = "No"
                                        
                                    }
                                    
                                    if driverStatus == "Delivered" {
                                        
                                        self.deliveredLabel.text = "Yes"
                                        
                                        self.pickedUpLabel.text = "Yes"
                                        
                                    } else {
                                        
                                        self.deliveredLabel.text = "No"
                                        
                                    }

                                    
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
