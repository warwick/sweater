//
//  WeatherViewModel.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import CoreData

class WeatherViewModel {

    private let _persistentContainer : NSPersistentContainer
    private let _user : User
    
    @Published var locationViewModels : [LocationViewModel] = []
    @Published var selectedCardIndex : Int = 0
    
    init(withPersistentContainer persistentContainer : NSPersistentContainer) {
        
        // Store away the persistent coordinator
        self._persistentContainer = persistentContainer
        
        do {
            
            // Fetch the user from the core data model, creating one if it doesn't exist
            self._persistentContainer.viewContext.refreshAllObjects()
            let userRequest = NSFetchRequest<User>(entityName: "User")
            let result = try self._persistentContainer.viewContext.fetch(userRequest)
            self._user = result.first ?? User(context: persistentContainer.viewContext)
            
            if self._user.locations?.count == 0 {
                
                // Create a new 'current location' card if we don't have any existing locations
                // This ensures that the user is never going to see a 'no content' state
                let currentLocation = Location(context: persistentContainer.viewContext)
                currentLocation.isCurrentLocation = true
                currentLocation.sortIndex = 0
                currentLocation.uuid = NSUUID().uuidString
                self._user.addToLocations(currentLocation)
                
            }
            
            // Fetch the locations from the model, creating a 'current location' model if no locations exist
            // Take the opportunity to sort them while we're at it, based on their sortIndex
            if let locations = self._user.locations as? Set<Location> {
                
                let sortedLocations = locations.sorted(by: { locationOne, locationTwo in
                    return locationOne.sortIndex < locationTwo.sortIndex
                })
                
                for location in sortedLocations {
                    let viewModel = LocationViewModel(withLocation: location, weatherViewModel: self)
                    self.locationViewModels.append(viewModel)
                }
            
            } else {
                
                let currentLocation = Location(context: persistentContainer.viewContext)
                currentLocation.isCurrentLocation = true
                currentLocation.sortIndex = 0
                currentLocation.uuid = NSUUID().uuidString

                let viewModel = LocationViewModel(withLocation: currentLocation, weatherViewModel: self)
                self.locationViewModels.append(viewModel)
                
            }
            
        } catch {
            assert(false, "There was an error loading from core data")
            self._user = User(context: persistentContainer.viewContext)
            self.locationViewModels = []
        }
        
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
        self.updateSelectedCard()
                    
    }
                
    /**
     The dot we should be selecting
     */

    func updateSelectedCard() {
        
        var selectedIndex = 0
        
        if let visibleCityId = self._user.lastVisibleCityId {
            for (i, location) in self.locationViewModels.enumerated() {
                if location.cityId() == visibleCityId {
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
    
    func addNewLocation(withCityName city : String, identifier: String) {
        
        // Check to see if a location with the same identifier already exists
        for location in self.locationViewModels {
            if location.cityId() == identifier {
                setSelectedCity(withId: identifier)
                return
            }
        }

        // We don't have any conflicts, we're good to make the new location
        let newCity = Location(context: _persistentContainer.viewContext)
        newCity.isCurrentLocation = false
        if let lastExistingViewModel = self.locationViewModels.last {
            newCity.sortIndex = lastExistingViewModel.sortIndex() + 1
        } else {
            newCity.sortIndex = 0
        }
        newCity.uuid = NSUUID().uuidString
        newCity.cityName = city
        newCity.cityId = identifier
        self._user.addToLocations(newCity)
        
        do {
            try self._user.managedObjectContext?.save()
        } catch {
            fatalError("Could not save core data")
        }

        let viewModel = LocationViewModel(withLocation: newCity, weatherViewModel: self)
        self.locationViewModels.append(viewModel)
        
        // Scroll to the city we just added
        setSelectedCity(withId: identifier)

    }
            
    func deleteLocation(withViewModel locationViewModel : LocationViewModel) {

        var selectedIndex = 0

        for (i, location) in self.locationViewModels.enumerated() {
            if location == locationViewModel {
                print("Found matching models: \(location.cityId()), \(locationViewModel.cityId())")
                selectedIndex = i
            }
        }
        
        self.locationViewModels.remove(at: selectedIndex)
        
    }
    
    func currentLocationViewModel() -> LocationViewModel? {
        
        if let visibleCityId = self._user.lastVisibleCityId {
            for location in self.locationViewModels {
                if location.cityId() == visibleCityId {
                    return location
                }
            }
        }
        
        return nil
        
    }

    
}
