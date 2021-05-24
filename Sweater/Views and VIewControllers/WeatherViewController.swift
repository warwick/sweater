//
//  ViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import Combine
import GooglePlaces

class WeatherViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GMSAutocompleteViewControllerDelegate {

    enum Section {
        case main
    }
    
    typealias LocationsDataSource = UICollectionViewDiffableDataSource<Section, LocationViewModel>
    typealias LocationsSnapshot = NSDiffableDataSourceSnapshot<Section, LocationViewModel>

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let weatherForLocationReuseIdentifier = "weatherForLocation"
    let settingsReuseIdentifier = "settings"
    
    var viewModel : WeatherViewModel?
    var selectedCardListener : AnyCancellable?
    var locationsListener : AnyCancellable?
    private lazy var dataSource = makeDataSource()
    
    let cityCreator = CityCreator()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedCardListener = viewModel?.$selectedCardIndex.sink(receiveValue: { index in
            self.configurePageControl(withIndex: index)
        })

        locationsListener = viewModel?.$locationViewModels.sink(receiveValue: { locationViewModels in
            self.applySnapshot(withLocationViewModels: locationViewModels, animatingDifferences: true)
        })

        self.collectionView.dataSource = dataSource
        
        if let locationViewModels = viewModel?.locationViewModels {
            applySnapshot(withLocationViewModels: locationViewModels)
        }

        if let viewModel = viewModel {
            configurePageControl(withIndex: viewModel.selectedCardIndex)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.selectedCardListener?.cancel()
        
    }
    
    func makeDataSource() -> LocationsDataSource {
        
        let dataSource = LocationsDataSource(collectionView: self.collectionView,
                                             cellProvider: { (collectionView, indexPath, locationViewModel) -> UICollectionViewCell? in
                                                
                                                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.weatherForLocationReuseIdentifier, for: indexPath)
                                                
                                                if let weatherCell = cell as?  WeatherForLocationCollectionViewCell {
                                                    weatherCell.viewModel = locationViewModel
                                                    weatherCell.configure()
                                                }
                                                
                                                return cell
                                                
                                             })
        
        return dataSource
        
    }
    
    func applySnapshot(withLocationViewModels locationViewModels: [LocationViewModel], animatingDifferences : Bool = true) {
        
        var snapshot = LocationsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(locationViewModels)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        configurePageControl(withIndex: pageControl.currentPage)
        
    }
    
    func configurePageControl(withIndex index : Int) {
        
        // Make sure the page control is setup with the right number of dots and the right images for those dots
        
        guard dataSource.numberOfSections(in: self.collectionView) == 1 else {
            return // The data source doesn't have any items yet, so we can't set the number of pages
        }
        
        self.pageControl.numberOfPages = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        
        for i in 0..<self.pageControl.numberOfPages {
            
            if let locationViewModel = dataSource.itemIdentifier(for: IndexPath(item: i, section: 0)) {
                if locationViewModel.isCurrentLocation() {
                    if let locationImage = UIImage(systemName: "location.fill") {
                        self.pageControl.setIndicatorImage(locationImage, forPage: i)
                    }
                } else {
                    self.pageControl.setIndicatorImage(nil, forPage: i)
                }
            }

        }
        
        self.pageControl.currentPage = index
        
        // Figure out how far the view should be scrolled, given the page index
        let scrollAmount = Int(self.collectionView.frame.size.width) * index
        let offset = CGPoint(x: scrollAmount, y: 0)
        self.collectionView.setContentOffset(offset, animated: true)
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.frame.size // We want our cells to fill the entire available area
        return cellSize
        
    }
        
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // Since we know that cells are one screenwidth, we can figure out where we're at for the paging indicator
        let cellIndex = Int(scrollView.contentOffset.x / self.collectionView.frame.size.width)

        if let locationViewModel = dataSource.itemIdentifier(for: IndexPath(item: cellIndex, section: 0)) {
            viewModel?.setSelectedCity(withId: locationViewModel.cityId())
        }

    }
    
    @IBAction func changePage(_ sender : UIPageControl) {
        
        if let locationViewModel = dataSource.itemIdentifier(for: IndexPath(item: sender.currentPage, section: 0)) {
            viewModel?.setSelectedCity(withId: locationViewModel.cityId())
        }
        
    }
    
    @IBAction func addLocation(_ sender : UIButton) {
        
        let autocompleteVC = GMSAutocompleteViewController()
        autocompleteVC.delegate = self
        autocompleteVC.placeFields = [.addressComponents]
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteVC.autocompleteFilter = filter
        
        self.present(autocompleteVC, animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        viewController.dismiss(animated: true, completion: nil)
        
        var countryCode = ""
        var cityName = ""
        
        if let addressComponents = place.addressComponents {
            for component in addressComponents {
                if component.types.contains("locality") {
                    if let city = component.shortName {
                        cityName = city
                    }
                }
                if component.types.contains("country") {
                    if let country = component.shortName {
                        countryCode = country
                    }
                }
            }
        }
        
        cityCreator.viewModel = self.viewModel
        cityCreator.createCity(forCityNamed: cityName, withCountryCode: countryCode, withParentViewController: self)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        let alert = UIAlertController(title: NSLocalizedString("Failed to autocomplete", comment: "Failed to autocomplete"),
                            message: NSLocalizedString("We were unable to autocomplete your search", comment: "Failed autocomplte"),
                          preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("Ok", comment: "Informational Modal Dismiss"),
                          style: .default,
                          handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    
}
