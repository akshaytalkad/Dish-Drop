//
//  DriverOrderMenuViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverOrderMenuViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var restaurantName: UILabel!
    @IBOutlet weak var mealProgramName: UILabel!
    
    var requestLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    
    var restName = ""
    var shelterName = ""
    
    var driverOrder = [String:Any]()
    var uid = ""
    
    let email = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
    
    @IBAction func restDirections(_ sender: Any) {
        
        
    }
    
    @IBAction func mealDirections(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantName.text = restName
        mealProgramName.text = shelterName
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate {
            driverLocation = coord
        }
        
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        
        Database.database().reference().child(email!).observeSingleEvent(of: .value) { [self] (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let firstName = value?["firstName"] as? String {
                
                if let lastName = value?["lastName"] as? String {
                    
                    let name = ("\(firstName)" + " " + "\(lastName)")
                    
                    Database.database().reference().child("Accepted-Offers").queryOrdered(byChild: "chosenRest").queryEqual(toValue: restName).observe(.childAdded) { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        
                        if let shelterName = value?["shelterName"] as? String {
                            
                            if let chosenRest = value?["chosenRest"] as? String {
                                
                                if let geolocation = value?["geolocation"] as? [Double] ?? [] {
                                    
                                    self.driverOrder = ["chosenRest" : chosenRest, "shelterName" : shelterName, "shelterLocation" : geolocation, "driverLat" : driverLocation.latitude, "driverLong" : driverLocation.longitude, "driverName" : name, "status" : "transit"]
                                    
                                    Database.database().reference().child("Transit-Orders").childByAutoId().setValue(self.driverOrder)
                                    
                                    Database.database().reference().child("Accepted-Offers").queryOrdered(byChild: "chosenRest").queryEqual(toValue: chosenRest).observe(.childAdded) { (snapshot) in
                                        
                                        snapshot.ref.removeValue()
                                        Database.database().reference().child("Accepted-Offers").removeAllObservers()
                                        
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
