//
//  MockNetworkManager.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import CoreData

class MockDataManager: NSObject {

    // This is a little class I'm using to put mock data into my model so that I can work on the app before getting networking up and running
    
    static let shared = MockDataManager()
    
    func loadMockData() { // Subtle.  Nuanced.  From the people who brought you 'I do not like this'
        
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            
            do {
                                
                // Find any existing users and nuke them from orbit
                let userRequest = NSFetchRequest<User>(entityName: "User")
                let result = try container.viewContext.fetch(userRequest)
                for user in result {
                    container.viewContext.delete(user)
                }
                
                // Create a fresh user
                let user = User(context: container.viewContext)
                user.preferredUnits = "metric"
                
                // Create a 'current location' item
                // We'll create one of these by default when the app first loads.  This won't be deletable.
                let currentLocation = Location(context: container.viewContext)
                currentLocation.isCurrentLocation = true
                currentLocation.sortIndex = 0
                currentLocation.uuid = NSUUID().uuidString
                currentLocation.isUpdatePending = true
                user.addToLocations(currentLocation)

                // Create an item for Vancouver
                let vancouver = Location(context: container.viewContext)
                vancouver.isCurrentLocation = false
                vancouver.sortIndex = 1
                vancouver.uuid = NSUUID().uuidString
                vancouver.isUpdatePending = true
                vancouver.cityName = "Vancouver"
                vancouver.cityId = "6173331"
                user.addToLocations(vancouver)

                // Create an item for San Francisco
                let sanFrancisco = Location(context: container.viewContext)
                sanFrancisco.isCurrentLocation = false
                sanFrancisco.sortIndex = 2
                sanFrancisco.uuid = NSUUID().uuidString
                sanFrancisco.isUpdatePending = true
                sanFrancisco.cityName = "San Francisco"
                sanFrancisco.cityId = "5391959"
                user.addToLocations(sanFrancisco)

                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
            } catch {
                print("Threw an exception while trying to fetch the user")
            }
            
        }
        
    }
    
}
