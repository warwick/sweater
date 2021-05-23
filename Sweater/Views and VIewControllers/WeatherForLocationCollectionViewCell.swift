//
//  WeatherForLocationCollectionViewCell.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import Combine

class WeatherForLocationCollectionViewCell: UICollectionViewCell {
            
    var viewModel: LocationViewModel?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var flavourText: UILabel!
    
    var temperatureListener : AnyCancellable?
    var temperatureAvailableListener : AnyCancellable?
    var weatherDescriptionListener : AnyCancellable?
    var highListener : AnyCancellable?
    var lowListener : AnyCancellable?
    var windListener : AnyCancellable?
    var humidityListener : AnyCancellable?
    var flavourTextListener : AnyCancellable?

    func configure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        deleteButton.isHidden = viewModel.isCurrentLocation()
        currentLocationLabel.isHidden = !viewModel.isCurrentLocation()
        temperature.text = viewModel.temperature
        degreesLabel.isHidden = !viewModel.temperatureAvailable
        cityName.text = viewModel.cityName()
        weatherDescription.text = viewModel.weatherDescription
        high.text = viewModel.todaysHigh
        low.text = viewModel.todaysLow
        wind.text = viewModel.todaysWind
        humidity.text = viewModel.todaysHumidity
        flavourText.text = viewModel.flavourText
        
        temperatureListener?.cancel()
        temperatureAvailableListener?.cancel()
        weatherDescriptionListener?.cancel()
        highListener?.cancel()
        lowListener?.cancel()
        windListener?.cancel()
        humidityListener?.cancel()
        flavourTextListener?.cancel()
        
        temperatureListener = viewModel.$temperature.sink(receiveValue: { value in
            self.temperature.text = value
        })

        temperatureAvailableListener = viewModel.$temperatureAvailable.sink(receiveValue: { value in
            self.degreesLabel.isHidden = !value
        })

        weatherDescriptionListener = viewModel.$weatherDescription.sink(receiveValue: { value in
            self.weatherDescription.text = value
        })

        highListener = viewModel.$todaysHigh.sink(receiveValue: { value in
            self.high.text = value
        })

        lowListener = viewModel.$todaysLow.sink(receiveValue: { value in
            self.low.text = value
        })

        windListener = viewModel.$todaysWind.sink(receiveValue: { value in
            self.wind.text = value
        })

        humidityListener = viewModel.$todaysHumidity.sink(receiveValue: { value in
            self.humidity.text = value
        })

        flavourTextListener = viewModel.$flavourText.sink(receiveValue: { value in
            self.flavourText.text = value
        })

        
    }
    
}
