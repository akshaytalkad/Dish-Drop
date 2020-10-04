//
//  AppDelegate.swift
//  Shelter Donation
//
//  Created by Siddharth on 10/2/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import Firebase
import RadarSDK
import FirebaseAuth
import CoreData
import FirebaseDatabase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RadarDelegate {
    
    var ref: DatabaseReference!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var localDict: [String: Int] = [:]
    var firstName = "", lastName = "", emailAddy = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Radar.initialize(publishableKey: "prj_test_pk_6ac0c3189de6d9849d46644d2ce54a7ae01156fb")
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        Radar.setDelegate(self)
        FirebaseApp.configure()
        return true
    }
    
    func didFail(status: RadarStatus) {}
    
    func didLog(message: String) {}
    
    func didReceiveEvents(_ events: [RadarEvent], user: RadarUser) { }
    
    func didUpdateLocation(_ location: CLLocation, user: RadarUser) { }
    
    func didUpdateClientLocation(_ location: CLLocation, stopped: Bool, source: RadarLocationSource) {
        
        Radar.searchPlaces(
            near: location,
            radius: 30,
            chains: [],
            categories: ["food-bank", "housing-homeless-shelter"],
            groups: nil,
            limit: 10
        ) { (status, location, places) in
            if(status == .success && places != nil && places!.count>0){
                // This is where all of the places that have been identified with a user will go to the database.
                for place in places!{
                    if self.localDict[place.name] != nil {
                        self.localDict[place.name]!+=1
                        if(self.localDict[place.name] == 5) {
                            Database.database().reference().child("premdhoot6-gmail-com").observeSingleEvent(of: .value) { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                self.firstName = value?["firstName"] as? String ?? ""
                                self.lastName = value?["lastName"] as? String ?? ""
                                self.emailAddy = value?["email"] as? String ?? ""
                                
                            }
                        }
                    }
                }
            }
            
            func configureDatabase() {
                self.ref = Database.database().reference()
            }
            
            
            // MARK: UISceneSession Lifecycle
            
            func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
                // Called when a new scene session is being created.
                // Use this method to select a configuration to create the new scene with.
                return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            }
            
            func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
                // Called when the user discards a scene session.
                // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
                // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
            }
            
            
        }
    }
}
