//
//  MapViewController.swift
//  Shelter Donation
//
//  Created by Akshay Talkad on 10/2/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var red: Bool = false
    var yellow: Bool = false
    var green: Bool = false
    var purple: Bool = false
    var locationManager = CLLocationManager()
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        switch Auth.auth().currentUser?.displayName {
        case "driver":
            performSegue(withIdentifier: "driverSegue", sender: self)
        case "restaurant":
            performSegue(withIdentifier: "restSegue", sender: self)
        case "shelter":
            performSegue(withIdentifier: "shelterSegue", sender: self)
        default:
            print("error")
        }
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var circlesDisplay: [MKCircle] = []
        
        self.mapView.delegate = self
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsTraffic = true
        mapView.showsCompass = false
        mapView.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let coordinate = CLLocationCoordinate2D.init(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let region = MKCoordinateRegion.init(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        self.locationManager = locationManager
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        
        let db = Firestore.firestore()
        db.collection("restaurant")
            .getDocuments() {
                (QuerySnapshot, Error) in
                for document in QuerySnapshot!.documents {
                    //green restaurant
                    if let status = document.get("status") as? String {
                        if status == "sent" {
                            self.green = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let greenRstrnt = MKPointAnnotation()
                                greenRstrnt.title =  document.get("name") as? String
                                greenRstrnt.subtitle = "Food has been picked up."
                                greenRstrnt.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(greenRstrnt)
                                let grnCir: MKCircle = MKCircle(center: greenRstrnt.coordinate, radius: 100)
                                circlesDisplay.append(grnCir)
                                self.mapView.addOverlay(grnCir)
                            }
                        }
                        
                        //yellow restaurant
                        if status == "reserved" {
                            self.yellow = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let yellowRstrnt = MKPointAnnotation()
                                yellowRstrnt.title =  document.get("name") as? String
                                yellowRstrnt.subtitle = "Driver has signed up and is ready to pick up."
                                yellowRstrnt.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(yellowRstrnt)
                                let ylwCir: MKCircle = MKCircle(center: yellowRstrnt.coordinate, radius: 100)
                                circlesDisplay.append(ylwCir)
                                self.mapView.addOverlay(ylwCir)
                            }
                        }
                        
                        if status == "offer" {
                            self.red = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let redRstrnt = MKPointAnnotation()
                                redRstrnt.title =  document.get("name") as? String
                                redRstrnt.subtitle = "Food to offer but needs driver sign-up."
                                redRstrnt.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(redRstrnt)
                                let redCir: MKCircle = MKCircle(center: redRstrnt.coordinate, radius: 100)
                                self.mapView.addOverlay(redCir)
                                circlesDisplay.append(redCir)
                                
                            }
                        }
                        
                        if status == "none" {
                            self.purple = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let purpleRstrnt = MKPointAnnotation()
                                purpleRstrnt.title = document.get("name") as? String
                                purpleRstrnt.subtitle = "Food to offer but needs driver sign-up."
                                purpleRstrnt.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(purpleRstrnt)
                                let prpCir: MKCircle = MKCircle(center: purpleRstrnt.coordinate, radius: 100)
                                self.mapView.addOverlay(prpCir)
                                circlesDisplay.append(prpCir)
                                
                            }
                        }
                    }
                }
            }
        
        db.collection("meal-program")
            .getDocuments() {
                (QuerySnapshot, Error) in
                
                for document in QuerySnapshot!.documents {
                    if let status = document.get("status") as? String {
                        print(status)
                        // green points
                        if status == "delivered" {
                            print("im in delivered")
                            self.green = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let greenAnnot = MKPointAnnotation()
                                greenAnnot.title = document.get("name") as? String
                                greenAnnot.subtitle = "Food has been delivered."
                                greenAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(greenAnnot)
                                let grnCir = MKCircle(center: greenAnnot.coordinate, radius: 100)
                                self.mapView.addOverlay(grnCir)
                                circlesDisplay.append(grnCir)
                            }
                        }
                        
                        //yellow points
                        if status == "transit" {
                            print("im in transit")
                            self.yellow = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let yellowAnnot = MKPointAnnotation()
                                yellowAnnot.title = document.get("name") as? String
                                yellowAnnot.subtitle = "Food is in transit."
                                yellowAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(yellowAnnot)
                                let ylwCir: MKCircle = MKCircle(center: yellowAnnot.coordinate, radius: 100)
                                self.mapView.addOverlay(ylwCir)
                                circlesDisplay.append(ylwCir)
                            }
                        }
                        
                        //red points
                        if status == "requested" {
                            self.red = true
                            if let geo = document.get("geolocation") as? [Double] {
                                let redAnnot = MKPointAnnotation()
                                redAnnot.title = document.get("name") as? String
                                redAnnot.subtitle = "Food is in transit."
                                redAnnot.coordinate = CLLocationCoordinate2D(latitude: geo[0], longitude: geo[1])
                                self.mapView.addAnnotation(redAnnot)
                                let redCir: MKCircle = MKCircle(center: redAnnot.coordinate, radius: 100)
                                self.mapView.addOverlay(redCir)
                                circlesDisplay.append(redCir)
                                
                            }
                        }
                    }
                    
                    
                    
                }
                
                if (circlesDisplay.count > 0) {
                    self.mapView.region = MKCoordinateRegion(center: circlesDisplay[0].coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    
                }
            }
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circles = MKCircleRenderer(overlay: overlay)
        circles.strokeColor = UIColor.black
        circles.lineWidth = 1.0
        
        if (green) {
            circles.fillColor = UIColor.green
        }
        
        if (yellow) {
            circles.fillColor = UIColor.yellow
        }
        
        if (purple) {
            
            circles.fillColor = UIColor.purple
            
        } else {
            
            circles.fillColor = UIColor.red
            
        }
        
        return circles
        
    }
    
    
}









extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}


