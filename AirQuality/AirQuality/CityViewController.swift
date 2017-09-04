//
//  CityViewController.swift
//  AirQuality
//
//  Created by Valmir Junior on 28/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    

    
    var country: Country?
    let cityServices: CityServices = OpenAQCityServices()
    let locationSegue = "cityLocation"
    
    var cities: [City] = [City]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        guard let country = self.country else {
            return
        }
        self.cityServices.retrieveCities(byCountry: country) {(cities) in
            if let cities = cities {
                DispatchQueue.main.async {
                    self.cities = cities
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == self.locationSegue)  {
            let locationViewController = segue.destination as? LocationViewController
            
            let city = sender as? City
            
            locationViewController?.city = city
        }
    }
    
}

extension CityViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        let currentCity = self.cities[indexPath.row]
        
        cell.cityName.text = currentCity.name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
}

extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityTouched = self.cities[indexPath.row]
        
        self.performSegue(withIdentifier: self.locationSegue, sender: cityTouched)
    }
}


