//
//  AcceptRestViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AcceptRestViewController: UIViewController {
    
    @IBOutlet weak var restName: UILabel!
    
    var restaurantName = ""
    
    var acceptedOfferDictionary = [String:Any]()
    
    let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        restName.text = restaurantName
                

    }
    
    @IBAction func acceptOrderPressed(_ sender: Any) {
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { (snapshot) in
                        
            let value = snapshot.value as? NSDictionary
            
            if let name = value?["name"] as? String ?? "" {
                
                if let geoLocation = value?["geolocation"] as? [Double] ?? [] {
                    
                    self.acceptedOfferDictionary = ["shelterName" : name, "shelterLocation" : geoLocation, "chosenRest" : self.restaurantName, "status" : "requested"]
                    
                    Database.database().reference().child("Accepted-Offers").childByAutoId().setValue(self.acceptedOfferDictionary)
                    
                    Database.database().reference().child("Outgoing-Offers").queryOrdered(byChild: "name").queryEqual(toValue: self.restaurantName).observe(.childAdded) { (snapshot) in
                        
                        
                        snapshot.ref.removeValue()
                        Database.database().reference().child("Outgoing-Offers").removeAllObservers()
                        
                    }
                }
                
            }
            
        }
        
        
        
    }

    

   
}
