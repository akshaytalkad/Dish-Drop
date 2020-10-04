//
//  DriverOrdersViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DriverOrdersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var acceptedOffers : [DataSnapshot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("Accepted-Offers").observe(.childAdded) { (snapshot) in
            
            self.acceptedOffers.append(snapshot)
            self.tableView.reloadData()
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }

    }

}

extension DriverOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return acceptedOffers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "acceptedOffers") as? AvailableRestTableViewCell
        
        let snapshot = acceptedOffers[indexPath.row]
        
        if let acceptedDictionary = snapshot.value as? [String:Any] {
            
            if let chosenRest = acceptedDictionary["chosenRest"] as? String {
                
                if let shelterName = acceptedDictionary["shelterName"] as? String {
                    
                    cell?.restName.text = "From: \(shelterName), To: \(chosenRest)"
                    
                }
                
            }
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snapshot = acceptedOffers[indexPath.row]
        self.performSegue(withIdentifier: "driverMenu", sender: snapshot)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let driverMenu = segue.destination as? DriverOrderMenuViewController {
            
            if let snapshot = sender as? DataSnapshot {
                
                if let driverOrder = snapshot.value as? [String:Any] {
                    
                    if let restName = driverOrder["chosenRest"] as? String {
                        
                        if let shelterName = driverOrder["shelterName"] as? String {
                            
                            print("-" + restName)
                            print("," + shelterName)
                            
                            driverMenu.restName = restName
                            driverMenu.shelterName = shelterName
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
}
