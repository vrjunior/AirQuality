//
//  OpenAQLocationServices.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQLocationServices: LocationServices {
    
    let locationsURL = "https://api.openaq.org/v1/locations"
    let cityParamKey = "city"
    let countryParamKey = "country"
    
    var measureServices:MeasurementServices? 

    func retrieveLocations(city: City, completion:@escaping ([Location]?) -> Void) {
        
        //Retrieve locations from city
        guard var urlComp = URLComponents(string: locationsURL) else {
            completion(nil)
            return
        }
        
        let urlCityParam = URLQueryItem(name: self.cityParamKey, value: city.name)
        
        let urlCountryParam = URLQueryItem(name: self.countryParamKey, value: city.country.code)
        
        urlComp.queryItems = [urlCountryParam, urlCityParam]
        
        guard let url = urlComp.url else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { [unowned self] (data, response, error) in
            
            if (error == nil && data != nil) {
                do {
                    let locationJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let  locations = self.parseLocations(locationJSON, city: city)
                        
                    completion(locations)
                    
                } catch {
                    completion(nil)
                }
            }
            
            completion(nil)
            
        }
        
        task.resume()
    }
    

    
    //MARK: - Location parsing methods
    
    func parseLocations(_ json:Any, city: City) -> [Location]? {
        
        var locations = [Location]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for locationData in results {
                    if let location = parseLocation(locationData, city: city) {
                        locations.append(location)
                    }
                }
            }
        }
        
        return locations

    }
    
    
    func parseLocation(_ json: Any, city: City) -> Location? {
        
        if let locationData = json as? NSDictionary {
            
            if let name = locationData["location"] as? String {
                
                let location = Location(name: name, city: city)

                return location
                
            }
            
        }
        
        return nil
        
    }
    

    
    
    

}
