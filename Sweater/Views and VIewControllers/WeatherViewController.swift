//
//  ViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import Combine

class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let weatherForLocationReuseIdentifier = "weatherForLocation"
    let settingsReuseIdentifier = "settings"
    
    var viewModel : WeatherViewModel?
    var selectedCardListener : AnyCancellable?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedCardListener = viewModel?.$selectedCardIndex.sink(receiveValue: { index in
            self.configurePageControl(withIndex: index)
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.selectedCardListener?.cancel()
        
    }
    
    func configurePageControl(withIndex index : Int) {
        
        guard let viewModel = viewModel else {
            assert(false, "No view model was set on the weather view controller.")
            return
        }
        
        // Make sure the page control is setup with the right number of dots and the right images for those dots
        self.pageControl.numberOfPages = viewModel.numberOfCards()
        for i in 0..<viewModel.numberOfCards() {
            if viewModel.cardType(atIndex: i) == .currentLocation {
                if let locationImage = UIImage(systemName: "location.fill") {
                    self.pageControl.setIndicatorImage(locationImage, forPage: i)
                }
            } else {
                self.pageControl.setIndicatorImage(nil, forPage: i)
            }
        }
        self.pageControl.currentPage = index
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.frame.size // We want our cells to fill the entire available area
        return cellSize
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfCards() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForLocationReuseIdentifier, for: indexPath)
        
        if let weatherCell = cell as?  WeatherForLocationCollectionViewCell {
            weatherCell.viewModel = viewModel?.locationViewModel(atIndex: indexPath.row)
            weatherCell.configure()
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let locationViewModel = viewModel?.locationViewModel(atIndex: indexPath.row) {
            viewModel?.setSelectedCity(withId: locationViewModel.cityId())
        }
        
    }


}
