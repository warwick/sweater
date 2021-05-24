//
//  WeatherForLocationCollectionViewCell.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import Combine

class WeatherForLocationCollectionViewCell: UICollectionViewCell {
        
    /**
     Outlets
     */
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var flavourText: UILabel!
    
    /**
     Supporting variables
     */
    var viewModel: LocationViewModel?

    var cityNameListener : AnyCancellable?
    var temperatureListener : AnyCancellable?
    var temperatureAvailableListener : AnyCancellable?
    var weatherDescriptionListener : AnyCancellable?
    var flavourTextListener : AnyCancellable?

    /**
     This sets up the views in the cell with data form the viewmodel, along with setting up callbacks so we'll get updated information when it's available.
     */
    func configure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        deleteButton.isHidden = viewModel.isCurrentLocation()
        currentLocationLabel.isHidden = !viewModel.isCurrentLocation()
        temperature.text = viewModel.temperature
        degreesLabel.isHidden = !viewModel.temperatureAvailable
        cityName.text = viewModel.cityName
        weatherDescription.text = viewModel.weatherDescription
        flavourText.text = viewModel.flavourText
        
        self.cancelListeners()
        
        cityNameListener = viewModel.$cityName.sink(receiveValue: { value in
            self.cityName.text = value
        })

        temperatureListener = viewModel.$temperature.sink(receiveValue: { value in
            self.temperature.text = value
        })

        temperatureAvailableListener = viewModel.$temperatureAvailable.sink(receiveValue: { value in
            self.degreesLabel.isHidden = !value
        })

        weatherDescriptionListener = viewModel.$weatherDescription.sink(receiveValue: { value in
            self.weatherDescription.text = value
        })

        flavourTextListener = viewModel.$flavourText.sink(receiveValue: { value in
            self.flavourText.text = value
        })

    }
    
    /**
     Cancel listeners so they're not hanging around past their usefulness.  We do this in a couple spots, so it's broken out here for DRY.
     */
    func cancelListeners() {
        cityNameListener?.cancel()
        temperatureListener?.cancel()
        temperatureAvailableListener?.cancel()
        weatherDescriptionListener?.cancel()
        flavourTextListener?.cancel()
    }
    
    /**
     When the user taps the 'x' button on a card, this fires, passing the request along to the viewModel who will handle it
     */
    @IBAction func deleteLocation(_ sender : Any) {
        viewModel?.deleteLocation()
    }
    
    /**
     We don't want to leave listeners hanging around after their useful lifespan.
     */
    deinit {
        self.cancelListeners()
    }
    
}
