//
//  DriverMenuViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DriverMenuViewController: UIViewController {
    
    var email = Auth.auth().currentUser?.email?.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    
    var driverStatus = [String:Any]()
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var pickedUpSwitch: UISwitch!
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    @IBAction func directionsToRest(_ sender: Any) {
        
    }
    @IBAction func directionToProgram(_ sender: Any) {
        
    }
    
    @IBAction func pickedUpSwitch(_ sender: Any) {
        
        if pickedUpSwitch.isOn {
            
            deliverySwitch.isEnabled = true
            
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let firstName = value?["firstName"] as? String {
                    
                    if let lastName = value?["lastName"] as? String {
                        
                        let fullName = firstName + " " + lastName
                        
                        Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "driverName").queryEqual(toValue: fullName).observe(.childAdded) { (snapshot) in
                            
                            self.driverStatus = ["driverStatus" : "Picked Up"]
                            snapshot.ref.updateChildValues(self.driverStatus)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
        } else {
            
            deliverySwitch.isEnabled = false
            
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let firstName = value?["firstName"] as? String {
                    
                    if let lastName = value?["lastName"] as? String {
                        
                        let fullName = firstName + " " + lastName
                        
                        Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "driverName").queryEqual(toValue: fullName).observe(.childAdded) { (snapshot) in
                            
                            self.driverStatus = ["driverStatus" : "-"]
                            snapshot.ref.updateChildValues(self.driverStatus)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
    @IBAction func deliverySwitch(_ sender: Any) {
        
        if deliverySwitch.isOn {
            
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let firstName = value?["firstName"] as? String {
                    
                    if let lastName = value?["lastName"] as? String {
                        
                        let fullName = firstName + " " + lastName
                        
                        Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "driverName").queryEqual(toValue: fullName).observe(.childAdded) { (snapshot) in
                            
                            self.driverStatus = ["driverStatus" : "Delivered"]
                            snapshot.ref.updateChildValues(self.driverStatus)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            
        } else {
            
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let firstName = value?["firstName"] as? String {
                    
                    if let lastName = value?["lastName"] as? String {
                        
                        let fullName = firstName + " " + lastName
                        
                        Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "driverName").queryEqual(toValue: fullName).observe(.childAdded) { (snapshot) in
                            
                            self.driverStatus = ["driverStatus" : "-"]
                            snapshot.ref.updateChildValues(self.driverStatus)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliverySwitch.isOn = false
        pickedUpSwitch.isOn = false
        
        deliverySwitch.isEnabled = false
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let firstName = value?["firstName"] as? String {
                
                if let lastName = value?["lastName"] as? String {
                    
                    let fullName = firstName + " " + lastName
                                            
                    Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "driverName").queryEqual(toValue: fullName).observe(.value) { (snapshot) in
                                                
                        let value = snapshot.value as? NSDictionary
                        
                        var uid = ""
                        
                        for snap in snapshot.children {
                            
                            let userSnap = snap as! DataSnapshot
                            
                            uid = userSnap.key
                            
                        }
                        
                        if let dict = value?["\(uid)"] as? [String:Any] {
                            
                            if let driverStatus = dict["driverStatus"] as? String {
                                
                                if let shelterName = dict["shelterName"] as? String {
                                    
                                    if let restName = dict["chosenRest"] as? String {
                                        
                                        self.overviewLabel.text = "From \(restName) to \(shelterName)"
                                        
                                        if driverStatus == "Picked Up" {
                                            
                                            self.pickedUpSwitch.isOn = true
                                            
                                            self.deliverySwitch.isEnabled = true
                                            
                                        }
                                        
                                        if driverStatus == "Delivered" {
                                            
                                            self.deliverySwitch.isOn = true
                                            
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
