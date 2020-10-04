//
//  AvailableRestViewController.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/3/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AvailableRestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurants : [DataSnapshot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("Outgoing-Offers").observe(.childAdded) { (snapshot) in
            
            self.restaurants.append(snapshot)
            self.tableView.reloadData()
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
            self.tableView.reloadData()
        }

    }


}

extension AvailableRestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurants.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restCell") as? AvailableRestTableViewCell
        
        let snapshot = restaurants[indexPath.row]
        
        if let restaurantsDictionary = snapshot.value as? [String:Any] {
            
            if let name = restaurantsDictionary["name"] as? String {
                
                if let location = restaurantsDictionary["location"] as? [Double] {
                    
                    cell?.restName.text = name
                    
                }
                
            }
            
            
        }
                
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snapshot = restaurants[indexPath.row]
        self.performSegue(withIdentifier: "restSegue", sender: snapshot)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let acceptRest = segue.destination as? AcceptRestViewController {
            
            if let snapshot = sender as? DataSnapshot {
                
                if let restaurant = snapshot.value as? [String:Any] {
                    
                    if let name = restaurant["name"] as? String {
                        
                        acceptRest.restaurantName = name
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
}
