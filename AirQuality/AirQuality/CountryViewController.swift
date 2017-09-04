//
//  CountryViewController.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet weak var countryTable: UITableView!
    
    var countries:[Country]? = [Country]()

    let citySegue = "countryCity"
    
    //MARK: - Services
    var countryServices: CountryServices = OpenAQCountryServices()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.countryTable.delegate = self
        
        countryServices.retrieveCoutries(completion: { [unowned self] (countries) in
            self.countries = countries
            //TODO: Assynchronously update Country table view
            DispatchQueue.main.async { [unowned self] in
                self.countryTable.reloadData()
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.citySegue {
            let locationViewController = segue.destination as? CityViewController
            
            let country = sender as? Country
            
            locationViewController?.country = country
        }
    }

}


extension CountryViewController:UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        
        let country = countries?[indexPath.row]
        
        cell.countryName.text = country?.name
        cell.flagIcon.image = FlagMapper.flagIcon(code: country?.code)
        
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
}

extension CountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCountry = countries?[indexPath.row]
        
        self.performSegue(withIdentifier: self.citySegue, sender: currentCountry)
    }
}
