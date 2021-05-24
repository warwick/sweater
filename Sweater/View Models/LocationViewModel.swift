//
//  LocationViewModel.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Combine

class LocationViewModel : Hashable {

    /**
     A few models and network helpers we don't want to expose directly
     */
    private let _location : Location
    private let _weatherViewModel : WeatherViewModel
    private let _networkClient : LocationWeatherLookup
    
    /**
     Helper variables
     */
    var weatherDescriptionListener : AnyCancellable?
    
    let unsetDoubleValue = -999.0 // We've set -1000 as the value for temperatures and other numbers that haven't been set in core data
    let unsetIntValue = -999 // We've set -1000 as the value for temperatures and other numbers that haven't been set in core data

    /**
     Observable variables
     */
    @Published var cityName = "--"
    @Published var weatherDescription = ""
    @Published var temperature = "--"
    @Published var temperatureAvailable = false
    @Published var flavourText = ""
    @Published var todaysHigh = "High: --"
    @Published var todaysLow = "Low: --"
    @Published var todaysWind = "Wind: --"
    @Published var todaysHumidity = "Humidity: --"
    
    /**
     Set up the location viewmodel.  This mostly consists of making sure we're calling all our formatting methods so they can assign values to our observable variables
     */
    init(withLocation location : Location, weatherViewModel: WeatherViewModel) {
        
        self._location = location
        self._weatherViewModel = weatherViewModel
        
        self._networkClient = LocationWeatherLookup()
                
        self._networkClient.viewModel = self
        self._networkClient.lookupWeather()
                
        // Update the view model with values that are saved in core data
        updateCityName()
        updateWeatherDescription()
        updateTemperature()
        updateTodaysHigh()
        updateTodaysLow()
        updateTodaysWind()
        updateTodaysHumidity()
        
        // We only want to do this on first load, it doesn't need to update everytime the temperature changes
        pickFlavourText()
        
    }
    
    /**
     Used by the diffable collection view controller
     */
    func hash(into hasher: inout Hasher) {
        hasher.combine(self._location.uuid)
    }
    
    /**
     Used by the diffable collection view controller
     */
    static func == (lhs: LocationViewModel, rhs: LocationViewModel) -> Bool {
        lhs._location.uuid == rhs._location.uuid
    }
    
    /**
     Exposes the sort index so we can make sure our locations always appear in the same order
     */
    func sortIndex() -> Int16 {
        return self._location.sortIndex
    }

    /**
     Tells us if this is a 'current location' card or not.  Current location cards don't show a delete button and indicate that they're the current location.
     */
    func isCurrentLocation() -> Bool {
        return self._location.isCurrentLocation
    }
        
    /**
     Exposes the cityId.  We don't make it observable since we don't expect it to change.
     */
    func cityId() -> String {
        return self._location.cityId ?? "UNKNOWN"
    }
    
    /**
     When the network call comes back with weather data, we drop it into the viewModel and let it update the model, as well as it's own formatting methods
     */
    func update(withWeatherData weatherData: GetCityByIdQuery.Data.GetCityById.Weather) {
        
        // Update the core data model
        self._location.cachedDescription = weatherData.summary?.description
        if let actualTemperature = weatherData.temperature?.actual {
            self._location.cachedTemperature = actualTemperature
        }
        if let highTemperature = weatherData.temperature?.max {
            self._location.cachedHigh = highTemperature
        }
        if let lowTemperature = weatherData.temperature?.min {
            self._location.cachedLow = lowTemperature
        }
        if let windSpeed = weatherData.wind?.speed {
            self._location.cachedWind = windSpeed
        }
        if let humidity = weatherData.clouds?.humidity {
            self._location.cachedHumidity = Int32(humidity)
        }
        
        do {
            try self._location.managedObjectContext?.save()
        } catch {
            assert(false, "We weren't able to save the managed object context.")
        }

        // I'd prefer to do this with callbacks on observed changes, but since Core Data doesn't seem to be marking properties as @Published, we'll update here.  Googling around indicates that it's buggy behaviour others are running into as well.
        updateCityName()
        updateWeatherDescription()
        updateTemperature()
        updateTodaysHigh()
        updateTodaysLow()
        updateTodaysWind()
        updateTodaysHumidity()
        
    }
    
    /**
     Formatting method
     */
    func updateCityName() {
        self.cityName = self._location.cityName ?? NSLocalizedString("--", comment: "Unknown City")
    }

    /**
     Formatting method
     */
    func updateWeatherDescription() {
        self.weatherDescription = self._location.cachedDescription ?? ""
    }

    /**
     Formatting method
     */
    func updateTemperature() {
        
        if self._location.cachedTemperature > unsetDoubleValue {
            
            // We have a valid temperature.  Show it rounded to the nearest whole number.
            let number = NSNumber(value: self._location.cachedTemperature)
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.numberStyle = .decimal
            
            if let formattedTemperature = numberFormatter.string(from: number) {
                self.temperature = formattedTemperature
                self.temperatureAvailable = true
                return
            }
            
        }
        
        self.temperature = "--"
        self.temperatureAvailable = false
        
    }

    /**
     Formatting method
     */
    func pickFlavourText() {
        
        // My intent here was to do something based on the 'feels like' temperature, but I realized I don't have enough data to
        // make any sort of accurate prediction.  If data isn't available, we'll have to rely on snark instead.
        // Here are a few 'funny' pieces of flavour text, one of which is picked at random for each location.
        
        let flavourText = [
            NSLocalizedString("Your mother wants you to bring a sweater, but your friends will all make fun of you.", comment: "Flavour text one"),
            NSLocalizedString("You should bring a sweater, that'll guarantee a sunny day.", comment: "Flavour text two"),
            NSLocalizedString("Wear that old college hoodie today.  It cost enough, who cares what the temperature is.", comment: "Flavour text three"),
            NSLocalizedString("Leave the sweater at home.  I'd like it to rain today.", comment: "Flavour text four"),
            NSLocalizedString("Dammit Jim, I'm a doctor, not a fashion oracle.  Put the damned sweater in your bag.", comment: "Flavour text five")
        ]
        
        self.flavourText = flavourText.randomElement() ?? ""
        
    }

    /**
     Formatting method
     */
    func updateTodaysHigh() {

        var text = "High: "

        if self._location.cachedHigh > unsetDoubleValue {
            
            // We have a valid temperature.  Show it rounded to the nearest whole number.
            let number = NSNumber(value: self._location.cachedHigh)
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.numberStyle = .decimal
            
            if let formattedTemperature = numberFormatter.string(from: number) {
                text += "\(formattedTemperature)°"
            } else {
                text += "--"
            }
            
        } else {
            text += "--"
        }
        
        self.todaysHigh = text
        
    }
    
    /**
     Formatting method
     */
    func updateTodaysLow() {

        var text = "Low: "

        if self._location.cachedLow > unsetDoubleValue {
            
            // We have a valid temperature.  Show it rounded to the nearest whole number.
            let number = NSNumber(value: self._location.cachedLow)
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.numberStyle = .decimal
            
            if let formattedTemperature = numberFormatter.string(from: number) {
                text += "\(formattedTemperature)°"
            } else {
                text += "--"
            }
            
        } else {
            text += "--"
        }

        self.todaysLow = text

    }

    /**
     Formatting method
     */
    func updateTodaysWind() {

        var text = "Wind: "

        if self._location.cachedWind > unsetDoubleValue {
            
            // We have a valid wind speed.  Show it rounded to the nearest whole number.
            let number = NSNumber(value: self._location.cachedWind)
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
            numberFormatter.numberStyle = .decimal
            
            if let formattedWind = numberFormatter.string(from: number) {
                text += "\(formattedWind) kph" // TODO: Change this so it's not metric specific
            } else {
                text += "--"
            }
            
        } else {
            text += "--"
        }

        self.todaysWind = text

    }

    /**
     Formatting method
     */
    func updateTodaysHumidity() {

        var text = "Humidity: "

        if self._location.cachedHumidity > unsetIntValue {
            text += "\(self._location.cachedHumidity)%"
        } else {
            text += "--"
        }

        self.todaysHumidity = text

    }
    
    /**
     When the UI wants to delete a location, it calls this.  We delete the model from core data and let the weather view model know that this object can go away.
     */
    func deleteLocation() {
        
        // In an ideal world, the model would be observed and the weather view model would be updated
        self._weatherViewModel.deleteLocation(withViewModel: self)

        if let managedObjectContext = self._location.managedObjectContext {
            managedObjectContext.delete(self._location)
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Unable to save to core data")
            }
        }
                
    }
    
    /**
     Used when a 'current location' is found from location services.  Updates out model so we can go and use our regular weather lookup functions.
     */
    func setCity(_ cityName : String, andCityId identifier : String) {
        
        // This is used when we're a 'current location' view model and we've found the location we're in now
        self._location.cityName = cityName
        self._location.cityId = identifier
        
        self._networkClient.lookupWeather()

    }


}
