//
//  LocationViewModel.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Combine

class LocationViewModel : Hashable {

    private let _location : Location
    private let _weatherViewModel : WeatherViewModel
    private let _networkClient : LocationWeatherLookup
    
    var weatherDescriptionListener : AnyCancellable?
    
    let unsetDoubleValue = -999.0
    let unsetIntValue = -999

    @Published var weatherDescription = ""
    @Published var temperature = "--"
    @Published var temperatureAvailable = false
    @Published var flavourText = ""
    @Published var todaysHigh = "High: --"
    @Published var todaysLow = "Low: --"
    @Published var todaysWind = "Wind: --"
    @Published var todaysHumidity = "Humidity: --"
    
    init(withLocation location : Location, weatherViewModel: WeatherViewModel) {
        
        self._location = location
        self._weatherViewModel = weatherViewModel
        
        self._networkClient = LocationWeatherLookup()
                
        self._networkClient.viewModel = self
        self._networkClient.lookupWeather()
                
        // Update the view model with values that are saved in core data
        updateWeatherDescription()
        updateTemperature()
        updateTodaysHigh()
        updateTodaysLow()
        updateTodaysWind()
        updateTodaysHumidity()
        
        // We only want to do this on first load, it doesn't need to update everytime the temperature changes
        pickFlavourText()
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self._location.uuid)
    }
    
    static func == (lhs: LocationViewModel, rhs: LocationViewModel) -> Bool {
        lhs._location.uuid == rhs._location.uuid
    }
    
    func sortIndex() -> Int16 {
        return self._location.sortIndex
    }

    func isCurrentLocation() -> Bool {
        return self._location.isCurrentLocation
    }
    
    func cityName() -> String {
        return self._location.cityName ?? NSLocalizedString("--", comment: "Unknown City")
    }
    
    func cityId() -> String {
        return self._location.cityId ?? "UNKNOWN"
    }
    
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
        updateWeatherDescription()
        updateTemperature()
        updateTodaysHigh()
        updateTodaysLow()
        updateTodaysWind()
        updateTodaysHumidity()
        
    }
    
    func updateWeatherDescription() {
        self.weatherDescription = self._location.cachedDescription ?? ""
    }

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

    func updateTodaysHumidity() {

        var text = "Humidity: "

        if self._location.cachedHumidity > unsetIntValue {
            text += "\(self._location.cachedHumidity)%"
        } else {
            text += "--"
        }

        self.todaysHumidity = text

    }
    
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

}
