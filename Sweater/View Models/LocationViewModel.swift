//
//  LocationViewModel.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit

class LocationViewModel: NSObject {

    private let _location : Location
    private let _networkClient : LocationWeatherLookup
    
    init(withLocation location : Location) {
        
        self._location = location
        
        self._networkClient = LocationWeatherLookup()
        
        super.init()
        
        self._networkClient.viewModel = self
        self._networkClient.lookupWeather()
        
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
    
    func weatherDescription() -> String {
        return self._location.cachedDescription ?? ""
    }
    
    func temperature() -> String {
        return self._location.cachedTemperature ?? "--"
    }
    
    func temperatureAvailable() -> Bool {
        return self._location.cachedTemperature != nil
    }

    func flavourText() -> String {
        // TODO: Some sort of calculation so this isn't just a static string
        return NSLocalizedString("Your mother wants you to bring a sweater, but your friends will all make fun of you.", comment: "Flavour text to describe the weather in terms of clothing")
    }
    
    func todaysHigh() -> String {
        
        var text = "High: "
        
        if let high = self._location.cachedHigh {
            text += "\(high)°"
        } else {
            text += "--"
        }
        
        return text
        
    }

    func todaysLow() -> String {
        
        var text = "Low: "
        
        if let low = self._location.cachedLow {
            text += "\(low)°"
        } else {
            text += "--"
        }
        
        return text
        
    }

    func todaysWind() -> String {
        
        var text = "Wind: "
        
        if let windSpeed = self._location.cachedWind {
            text += "\(windSpeed) kph" // TODO: Change this so it's not metric specific
        } else {
            text += "--"
        }
        
        return text
        
    }

    func todaysHumidity() -> String {
        
        var text = "Humidity: "
        
        if let humidity = self._location.cachedHumidity {
            text += "\(humidity)%"
        } else {
            text += "--"
        }
        
        return text
        
    }

}
