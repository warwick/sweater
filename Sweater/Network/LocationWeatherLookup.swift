//
//  LocationWeatherLookup.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Apollo
import CoreLocation

class LocationWeatherLookup: NSObject, CLLocationManagerDelegate {
        
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://graphql-weather-api.herokuapp.com/")!)
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var viewModel : LocationViewModel?
    
    /**
        Fires off a weather lookup request and updates our view model with the results
     */
    func lookupWeather() {
                
        guard let viewModel = viewModel else {
            return
        }
        
        if viewModel.isCurrentLocation() {
            
            // We have a slightly different flow for lookup if it's a 'current location' card, so head into a specialized method
            lookupCurrentLocationWeather()
            return
            
        }

        
        self.apollo.fetch(query: GetCityByIdQuery(cityId: [viewModel.cityId()])) { result in
          switch result {
          case .success(let graphQLResult):
            if let weatherData = graphQLResult.data?.getCityById?.first??.weather {
                viewModel.update(withWeatherData: weatherData)
            }
          case .failure(let error):
            print("Failure to load weather data! Error: \(error)")
          }
        }

    }
    
    /**
     Starts locations services up so that we can lookup where we are.
     We use this information to display local weather to the user.
     */
    func lookupCurrentLocationWeather() {
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
    }
    
    /**
     Our implemtation of the location manager callback.
     Results in us figuring out which city we're in and updating the 'current location' model appropriately.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // When we expand this app to support refreshing outside of the initial load, maybe we'll need to turn this back on periodically, but until then it's just disrespecfully wasting the users battery.
        
        locationManager.stopUpdatingLocation()
        
        if let location = locations.first {
            
            geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                
                if error != nil {
                    print("Error reverse geocoding location: \(error)") // TODO: Figure out a way to reflect this in the UI before we ship this.
                    return
                }
                
                if let placemark = placemarks?.first {
                    
                    let country = placemark.isoCountryCode ?? ""
                    let city = placemark.locality ?? ""
                    
                    self.apollo.fetch(query: GetCityByNameQuery(cityName: city, country: country)) { result in
                        switch result {
                        case .success(let graphQLResult):
                            
                            // Check to see that we've gotten an id back from the graphQL call
                            if let identifier = graphQLResult.data?.getCityByName?.id {
                                self.viewModel?.setCity(city, andCityId: identifier)
                            }
                            
                        case .failure(let error):
                            print("Failure: \(error)")
                        }
                    }

                }
                
                
            }
            
        }
        
    }

}
