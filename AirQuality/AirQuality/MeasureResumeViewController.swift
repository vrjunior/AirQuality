//
//  MeasureResumeViewController.swift
//  AirQuality
//
//  Created by Valmir Junior on 01/09/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class MeasureResumeViewController: UIViewController {
    
    
    let measureServices: MeasurementServices = OpenAQMeasureServices()
    let aqiAssistance: AQIAssistance = AQIAssistance()
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var aqiLevel: UILabel!
    @IBOutlet weak var aqisCollectionView: UICollectionView!
    
    var currentLocation: Location?
    var today: Date!
    var dateFormatter = DateFormatter()
    
    var measuresIndexes = [(MeasureType, AQILevel)]() {
        didSet {
            DispatchQueue.main.async {
                self.aqisCollectionView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.today = Date()
        self.dateFormatter.dateStyle = .medium
        
        //setting data source
        self.aqisCollectionView.dataSource = self
        
        if let currentLocation = self.currentLocation {
            
            self.location.text = currentLocation.name
            self.city.text = currentLocation.city.name
            
            self.date.text = self.dateFormatter.string(from: today)
            
            self.measureServices.getMeasures(forLocation: currentLocation, fromDate: self.today) {
                (measures) in
                
            
                if let measures = measures {
                
                    //getting the indexes caculated
                    let aqiIndexes = self.aqiAssistance.getAqiIndexes(measures: measures)
                    
                    //setting to data source of collection view
                    self.measuresIndexes = aqiIndexes
                    
                    //getting the worst index to show
                    let currentIndex = aqiIndexes.first?.1.description
                    
                    //showing the worst index
                    self.aqiLevel.text = currentIndex
                }
                
            }
            
        }
    }
    
    
}


extension MeasureResumeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.measuresIndexes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentMeasure = self.measuresIndexes[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeasureCell", for: indexPath) as! MeasureCell
        
        cell.element.text = currentMeasure.0.rawValue
        cell.aqiIndex.text = currentMeasure.1.description
        
        return cell
    }
    
}
