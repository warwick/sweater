//
//  ViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit
import Combine

class WeatherViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedCardListener = viewModel?.$selectedCardIndex.sink(receiveValue: { index in
            self.configurePageControl(withIndex: index)
        })
        
        self.collectionView.dataSource = dataSource
        applySnapshot()

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
    
    func applySnapshot(animatingDifferences : Bool = true) {

        guard let viewModel = viewModel else {
            return
        }
        
        var snapshot = LocationsSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.locationViewModels())
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

}
