//
//  LocationWeatherLookup.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Apollo

class LocationWeatherLookup: NSObject {
        
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://graphql-weather-api.herokuapp.com/")!)

    var viewModel : LocationViewModel?
    
    func lookupWeather() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        self.apollo.fetch(query: GetCityByIdQuery(cityId: [viewModel.cityId()])) { result in
          switch result {
          case .success(let graphQLResult):
            print("Success! Result: \(graphQLResult)")
          case .failure(let error):
            print("Failure! Error: \(error)")
          }
        }

    }
    

}
