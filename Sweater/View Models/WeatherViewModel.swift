//
//  WeatherViewModel.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import CoreData

class WeatherViewModel: NSObject, ObservableObject {

    private let _persistentContainer : NSPersistentContainer
    private let _user : User
    private let _locations : [Location]
    
    @Published var selectedCardIndex : Int = 0

    enum CardType {
        case currentLocation
        case savedLocation
    }
    
    init(withPersistentContainer persistentContainer : NSPersistentContainer) {
        
        // Store away the persistent coordinator
        self._persistentContainer = persistentContainer
        
        do {
            
            // Fetch the user from the core data model, creating one if it doesn't exist
            self._persistentContainer.viewContext.refreshAllObjects()
            let userRequest = NSFetchRequest<User>(entityName: "User")
            let result = try self._persistentContainer.viewContext.fetch(userRequest)
            self._user = result.first ?? User(context: persistentContainer.viewContext)
                    
            // Fetch the locations from the model, creating a 'current location' model if no locations exist
            // Take the opportunity to sort them while we're at it, based on their sortIndex
            if let locations = self._user.locations as? Set<Location> {
                
                self._locations = locations.sorted(by: { locationOne, locationTwo in
                    return locationOne.sortIndex < locationTwo.sortIndex
                })
            
            } else {
                
                let currentLocation = Location(context: persistentContainer.viewContext)
                currentLocation.isCurrentLocation = true
                currentLocation.sortIndex = 0
                currentLocation.uuid = NSUUID().uuidString
                currentLocation.isUpdatePending = true

                self._locations = [currentLocation]
                
            }
            
        } catch {
            assert(false, "There was an error loading from core data")
            self._user = User(context: persistentContainer.viewContext)
            self._locations = []
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        super.init()
        
        self.updateSelectedCard()
                    
    }
    
    /**
     
     One card per location.
     
     */
    func numberOfCards() -> Int {
        return self._locations.count
    }
    
    /**
        Cards can be either `currentLocation` or `savedLocation.
     */
    func cardType(atIndex index : Int) -> CardType {
        
        let card = self._locations[index]
        if card.isCurrentLocation {
            return .currentLocation
        } else {
            return .savedLocation
        }
        
    }
    
    /**
     The dot we should be selecting
     */

    func updateSelectedCard() {
        
        var selectedIndex = 0
        
        if let visibleCityId = self._user.lastVisibleCityId {
            for (i, location) in self._locations.enumerated() {
                if location.cityId == visibleCityId {
                    selectedIndex = i
                }
            }
        }
        
        self.selectedCardIndex = selectedIndex
        
    }
    
    func setSelectedCity(withId id : String) {
        self._user.lastVisibleCityId = id
        updateSelectedCard()
    }
    
    func locationViewModel(atIndex index : Int) -> LocationViewModel {
        
        let location = self._locations[index]
        let viewModel = LocationViewModel(withLocation: location)
        
        return viewModel
        
    }
    
}
