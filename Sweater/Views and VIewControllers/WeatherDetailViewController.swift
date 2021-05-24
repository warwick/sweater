//
//  WeatherDetailViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Combine

class WeatherDetailViewController: UIViewController {

    var viewModel : LocationViewModel?

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!

    var weatherDescriptionListener : AnyCancellable?
    var highListener : AnyCancellable?
    var lowListener : AnyCancellable?
    var windListener : AnyCancellable?
    var humidityListener : AnyCancellable?

    
    override func viewDidLoad() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        cityName.text = viewModel.cityName()
        weatherDescription.text = viewModel.weatherDescription
        high.text = viewModel.todaysHigh
        low.text = viewModel.todaysLow
        wind.text = viewModel.todaysWind
        humidity.text = viewModel.todaysHumidity
        
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

    }
    
    func cancelListeners() {
        weatherDescriptionListener?.cancel()
        highListener?.cancel()
        lowListener?.cancel()
        windListener?.cancel()
        humidityListener?.cancel()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.cancelListeners()
    }
    
}
