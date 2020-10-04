//
//  RestaurantMenuViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RestaurantMenuViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var restName: UILabel!
    
    let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    
    var restaurantName = ""
    var transitUID = ""
    
    var outgoingOffersDictionary = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let restName = value?["name"] as? String {
                
                self.restName.text = restName
                            
                DispatchQueue.main.async {
                    
                    Database.database().reference().child("Accepted-Offers").queryOrdered(byChild: "chosenRest").queryEqual(toValue: restName).observe(.value) { (snapshot) in
                                                
                        let value = snapshot.value as? NSDictionary
                        
                        var uid = ""
                        
                        for snap in snapshot.children {
                            
                            let userSnap = snap as! DataSnapshot
                            
                            uid = userSnap.key
                            
                        }
                        
                        if let dict = value?["\(uid)"] as? [String:Any] {
                            
                            if let status = dict["status"] as? String {
                                
                                if let shelterName = dict["shelterName"] as? String {
                                    
                                    if status == "requested" {
                                        
                                        self.statusLabel.text = "\(shelterName) has requested an order from you"
                                        
                                        self.switchButton.isOn = true
                                        
                                        self.switchButton.isEnabled = false
                                        
                                    } else {
                                        
                                        self.statusLabel.text = "Offer not Claimed Yet"
                                        
                                        self.switchButton.isOn = true
                                        
                                        self.switchButton.isEnabled = true
                                        
                                    }
                                    
                                }
                            
                                
                            }
                            
                        }
                        
                        Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "chosenRest").queryEqual(toValue: restName).observe(.value) { (snapshot) in
                            
                            let value = snapshot.value as? NSDictionary
                            
                            for snap in snapshot.children {
                                
                                let driverSnap = snap as! DataSnapshot
                                
                                self.transitUID = driverSnap.key
                                
                            }
                            
                            if let dict = value?["\(self.transitUID)"] as? [String:Any] {
                                
                                if let status = dict["status"] as? String {
                                    
                                    if let shelterName = dict["shelterName"] as? String {
                                        
                                        if status == "transit" {
                                            
                                            self.statusLabel.text = "The driver has accepted the offer"
                                            
                                            self.switchButton.isOn = true
                                            
                                            self.switchButton.isEnabled = false
                                            
                                        } else if status == "delivered" {
                                            
                                            self.statusLabel.text = "Order has been delivered to \(shelterName)"
                                            
                                            self.switchButton.isOn = false
                                            
                                            self.switchButton.isEnabled = true
                                            
                                            Database.database().reference().child("Transit-Orders").queryOrdered(byChild: "chosenRest").queryEqual(toValue: restName).observe(.childAdded) { (snapshot) in
                                                
                                                snapshot.ref.removeValue()
                                                Database.database().reference().child("Transit-Orders").removeAllObservers()
                                                
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
        
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        
        if switchButton.isOn {
            
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let name = value?["name"] as? String ?? "" {
                    
                    if let geoLocation = value?["geolocation"] as? [Double] ?? [] {
                        
                        
                        
                        self.outgoingOffersDictionary = ["name" : name, "location" : geoLocation]
                        
                        Database.database().reference().child("Outgoing-Offers").childByAutoId().setValue(self.outgoingOffersDictionary)
                        
                    }
                    
                    
                }
                
                
            }
            
            
        } else {
                        
            Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let name = value?["name"] as? String ?? "" {
                    
                    Database.database().reference().child("Outgoing-Offers").queryOrdered(byChild: "name").queryEqual(toValue: name).observe(.childAdded) { (snapshot) in
                        
                        snapshot.ref.removeValue()
                        Database.database().reference().child("Outgoing-Offers").removeAllObservers()
                        
                    }
                    
                }
                                
            }
            
        }
        
        
    }
    
    
    
}
