//
//  OpenAQCityServices.swift
//  AirQuality
//
//  Created by Valmir Junior on 24/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQCityServices : CityServices {
    let cityURL = "https://api.openaq.org/v1/cities"
    let countryField = "country"
    
    func retrieveCities(byCountry country: Country, completion: @escaping ([City]?) -> Void) {
        
        guard var urlComp = URLComponents(string: cityURL) else {
            completion(nil)
            return
        }
        
        let urlCountryQuery = URLQueryItem(name: countryField, value: country.code)
        
        urlComp.queryItems = [urlCountryQuery]
        
        guard let url = urlComp.url else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let urlConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: urlConfiguration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil  && data != nil {
                do {
                    let citiesJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let cities = self.parseCities(json: citiesJSON, country: country)
                    
                    completion(cities)
                }
                catch {
                    completion(nil)
                }
                
            }
            else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func parseCities(json: Any, country: Country) -> [City]? {
        
        
        if let json = json as? NSDictionary {
        
            if let results = json["results"] as? NSArray {
                var cities = [City]()
                
                for cityData in results {
                    if let city = parseCity(json: cityData, country: country) {
                        cities.append(city)
                    }
                }
                
                return cities
            }
        }
        
        return nil
    }
    
    func parseCity(json: Any, country: Country) -> City? {
        
        if let cityData = json as? NSDictionary {
            
            if let cityName = cityData["city"] as? String {
                return City(name: cityName, country: country)
            }
        }
        
        return nil
        
    }
}
