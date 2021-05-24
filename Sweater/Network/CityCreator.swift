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
    var parentViewController: UIViewController?
    
    func createCity(forCityNamed city : String, withCountryCode country : String, withParentViewController parentViewController: UIViewController) {
        
        self.parentViewController = parentViewController
        
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
        
        let alertTitle = NSLocalizedString("Unable to Create Location", comment: "Unable to Create Location")
        let alertMessage = NSLocalizedString("We weren't able to create a location.  Put on a sweater and try again later.", comment: "Unable to Create Location Details")
        let alertActionTitle = NSLocalizedString("Ok", comment: "Informational Modal Dismiss")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: alertActionTitle, style: .default, handler: nil)
        alert.addAction(alertAction)
        
        self.parentViewController?.present(alert, animated: true, completion: nil)
        
    }
    
}
