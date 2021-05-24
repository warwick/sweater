//
//  WeatherDetailViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-23.
//

import UIKit
import Combine

class WeatherDetailViewController: UIViewController {

    /**
     Outlets
     */
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!

    /**
     Supporting variables
     */
    var viewModel : LocationViewModel?

    var cityNameListener : AnyCancellable?
    var weatherDescriptionListener : AnyCancellable?
    var highListener : AnyCancellable?
    var lowListener : AnyCancellable?
    var windListener : AnyCancellable?
    var humidityListener : AnyCancellable?
    
    /**
     Setup the detail view with text from the view model, and set up some listeners so the text will update if the viewmodel changes
     */
    override func viewDidLoad() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        cityName.text = viewModel.cityName
        weatherDescription.text = viewModel.weatherDescription
        high.text = viewModel.todaysHigh
        low.text = viewModel.todaysLow
        wind.text = viewModel.todaysWind
        humidity.text = viewModel.todaysHumidity
        
        cityNameListener = viewModel.$cityName.sink(receiveValue: { value in
            self.cityName.text = value
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

    }
    
    /**
     This doesn't really need to be broken out, but I think the naming makes it more obvious what's happening in viewWillDisappear
     */
    func cancelListeners() {
        cityNameListener?.cancel()
        weatherDescriptionListener?.cancel()
        highListener?.cancel()
        lowListener?.cancel()
        windListener?.cancel()
        humidityListener?.cancel()
    }
        
    /**
     Don't leave unneeded listeners hanging around
     */
    override func viewWillDisappear(_ animated: Bool) {
        self.cancelListeners()
    }
    
}
