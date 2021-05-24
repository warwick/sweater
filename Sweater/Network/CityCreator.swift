//
//  CityCreator.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Apollo

class CityCreator: NSObject {

    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://graphql-weather-api.herokuapp.com/")!)

    var viewModel : WeatherViewModel?
    
    func createCity(forCityNamed city : String, withCountryCode country : String, withParentViewController: UIViewController) {
        
        guard let viewModel = viewModel else {
            showErrorAlert()
            return
        }
        
        self.apollo.fetch(query: GetCityByNameQuery(cityName: city, country: country)) { result in
            switch result {
            case .success(let graphQLResult):
                
                // Check to see that we've gotten an id back from the graphQL call
                if let identifier = graphQLResult.data?.getCityByName?.id {
                    print("The city identifier is: \(identifier)")
                    viewModel.addNewLocation(withCityName: city, identifier: identifier)
                }
                
//              if let weatherData = graphQLResult.data?.getCityById?.first??.weather {
//                  viewModel.update(withWeatherData: weatherData)
//              }
            case .failure(let error):
                print("Failure: \(error)")
                self.showErrorAlert()
            }
        }
        
    }

    func showErrorAlert() {
        // TODO: We need to show an alert modal on the parent view controller sine we won't be able to add the location
    }
    
}
