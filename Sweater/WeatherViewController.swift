//
//  ViewController.swift
//  Sweater
//
//  Created by Bob Warwick on 2021-05-22.
//

import UIKit

class WeatherViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let weatherForLocationReuseIdentifier = "weatherForLocation"
    let settingsReuseIdentifier = "settings"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let locationImage = UIImage(systemName: "location.fill") {
            self.pageControl.setIndicatorImage(locationImage, forPage: 0)
        }
        
        if let addImage = UIImage(systemName: "gearshape.fill") {
            self.pageControl.setIndicatorImage(addImage, forPage: 2) // Temp to check for looks as we design ui
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.frame.size // We want our cells to fill the entire available area
        
        return cellSize
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Quick and dirty, let's get things onscreen while we design
        
        if indexPath.row < 6 {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherForLocationReuseIdentifier, for: indexPath)
            return cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsReuseIdentifier, for: indexPath)
        return cell
        
    }


}
