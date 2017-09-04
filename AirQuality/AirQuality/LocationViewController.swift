//
//  LocationViewController.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var city: City?
    let measureSegue = "locationMeasure"
    
    @IBOutlet weak var locationTable: UITableView!
    
    var locations:[Location] = [Location]()
    
    //MARK: - Services
    var countryServices: LocationServices = OpenAQLocationServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting delegates
        self.locationTable.dataSource = self
        self.locationTable.delegate = self
        
        //Inversion of Control
        countryServices.measureServices = OpenAQMeasureServices()
        
        // Do any additional setup after loading the view.
        if let city = self.city {
            countryServices.retrieveLocations(city: city, completion: { [unowned self] (locations) in

                if let locations = locations {
                    self.locations = locations
                }
               
                DispatchQueue.main.async { [unowned self] in
                    self.locationTable.reloadData()
                }
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == self.measureSegue) {
            let measureViewController = segue.destination as! MeasureResumeViewController
            
            let location = sender as! Location
            
            measureViewController.currentLocation = location
            
        }
    }
    

}

extension LocationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentLocation = self.locations[indexPath.row]
        
        self.performSegue(withIdentifier: self.measureSegue, sender: currentLocation)
    }
    
}

extension LocationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        let currentLocation = self.locations[indexPath.row]
        
        cell.locationName.text = currentLocation.name
        
        return cell
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
}
