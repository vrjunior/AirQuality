//
//  OpenAQCountryServices.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQCountryServices: CountryServices {
    
    let countryURL = "https://api.openaq.org/v1/countries"
    
    func retrieveCoutries(completion:@escaping ([Country]?) -> Void) {
        
        guard let url = URL(string: countryURL) else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if (error == nil && data != nil) {
                do {
                    let countryJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let countries = self.parseCountries(countryJSON)
                    completion(countries)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    //MARK: Countries JSON parsinh methods
    
    
    /// Parse the country list
    ///
    /// - Parameter json: JSON fragment containgin the countries list
    /// - Returns: List of countries parsed from JSON
    func parseCountries(_ json:Any) -> [Country]? {
        
        var countries = [Country]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for countryData in results {
                    if let country = parseCountry(countryData) {
                            countries.append(country)
                    }
                }
            }
        }
        
        return countries
        
    }
    
    
    /// Parse a country data from JSON
    ///
    /// - Parameter json: JSOn fragment containing the country definition
    /// - Returns: A country parsed from given JSON, if valid, nil otherwise
    func parseCountry(_ json: Any) -> Country? {
        
        if let countryData = json as? NSDictionary {
            
            if let code = countryData["code"] as? String,
            let name = countryData["name"] as? String {
                return Country(name: name, code: code)
            }
            
        }
        
        return nil
        
    }
    

}
