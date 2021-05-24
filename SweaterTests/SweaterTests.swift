//
//  SweaterTests.swift
//  SweaterTests
//
//  Created by Bob Warwick on 2021-05-22.
//

import XCTest
@testable import Sweater

class SweaterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // A basic test of the weather viewmodel to make sure that it reflects the data we see in the model
    func testWeatherViewModel() throws {
        
        MockDataManager.shared.loadMockData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        
        let viewModel = WeatherViewModel(withPersistentContainer: persistentContainer)
        
        XCTAssert(viewModel.selectedCardIndex == 0, "We started with the wrong selected index")
        XCTAssert(viewModel.locationViewModels.count == 3, "There's something out of whack with the location view models")
        
    }

    // A basic test of a location viewmodel to make sure it's getting instantiated and has some visibility on the data
    func testLocationViewModel() throws {
        
        MockDataManager.shared.loadMockData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        
        let weatherViewModel = WeatherViewModel(withPersistentContainer: persistentContainer)
        let locationsViewModel = weatherViewModel.locationViewModels[1]
        
        XCTAssert(locationsViewModel.cityName == "Vancouver")
        
    }

}
