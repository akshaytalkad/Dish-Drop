//
//  DatabaseManager.swift
//  Shelter Donation
//
//  Created by Prem Dhoot on 10/2/20.
//  Copyright © 2020 Siddharth Cherukupalli. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
    
}

extension DatabaseManager {
    
    public func insertDriver(with user: Driver, completion: @escaping (Bool) -> Void) {
        
        database.child(user.safeEmail).setValue([
            
            "firstName" : user.firstName,
            "lastName" : user.lastName
            
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            
        })
        
    }
    
    public func insertRestaurant(with user: Restaurant, completion: @escaping (Bool) -> Void) {
        
        database.child(user.safeEmail).setValue([
            
            "name" : user.name,
            "geolocation" : user.geolocation,
            "mealsProvided" : 0,
        
        ], withCompletionBlock: {error, _ in
            
            guard error == nil else {
                completion(false)
                return
            }
            
        })
        
    }
    
    public func insertShelter(with user: MealProgram, completion: @escaping (Bool) -> Void) {
        
        database.child(user.safeEmail).setValue([
        
            "name" : user.name,
            "geolocation" : user.geolocation
        
        ], withCompletionBlock: {error, _ in
            
            guard error == nil else {
                completion(false)
                return
            }
           
        })
        
        
    }
        
}

struct User {
    
    let firstName: String
    let lastName: String
    let email: String
    
    var safeEmail: String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

struct Restaurant {
    
    let geolocation: [Double]
    let name: String
    let mealsProvided: Int
    let email: String
    
    var safeEmail: String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

struct MealProgram {
    
    let geolocation: [Double]
    let name: String
    let email: String
    
    var safeEmail: String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct Driver {
    
    let firstName: String
    let lastName: String
    
    let email: String
    
    var safeEmail: String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
