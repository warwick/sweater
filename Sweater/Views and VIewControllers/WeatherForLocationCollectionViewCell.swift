//
//  WeatherForLocationCollectionViewCell.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit

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
    
    func configure() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        deleteButton.isHidden = viewModel.isCurrentLocation()
        currentLocationLabel.isHidden = !viewModel.isCurrentLocation()
        temperature.text = viewModel.temperature()
        degreesLabel.isHidden = !viewModel.temperatureAvailable()
        cityName.text = viewModel.cityName()
        weatherDescription.text = viewModel.weatherDescription()
        high.text = viewModel.todaysHigh()
        low.text = viewModel.todaysLow()
        wind.text = viewModel.todaysWind()
        humidity.text = viewModel.todaysHumidity()
        flavourText.text = viewModel.flavourText()
        
    }
    
}
