//
//  OpenAQMeasureServices.swift
//  AirQuality
//
//  Created by Sergio Ordine on 8/22/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQMeasureServices: MeasurementServices {
    
    let measuresURL = "https://api.openaq.org/v1/latest"
    let locationKey = "location"
    let dateKey = "dateFrom"
    
    var dateFormatter:DateFormatter!
    
    init() {
        
        //Initialize the data formatter (Local time)
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
    }
    
    func getMeasures(forLocation location: Location, fromDate date:Date, completion: @escaping ([Measure]?) -> Void) {
        
        self.retrieveMeasures(location: location, fromDate: date) {
            (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
    }
    
    fileprivate func retrieveMeasures(location:Location, fromDate date:Date, completion:@escaping ([Measure]?) -> Void) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateFormatted = formatter.string(from: date)
        
        //Retrieve locations from city
        guard var urlComp = URLComponents(string: self.measuresURL) else {
            completion(nil)
            return
        }
        
        //creating url params query
        let locationURLQuery = URLQueryItem(name: self.locationKey, value: location.name)
        let dateURLQuery = URLQueryItem(name: self.dateKey, value: dateFormatted)
        
        //including fields param query
        let includeFielsURLQuery = URLQueryItem(name: "include_fields", value: "averagingPeriod")
        
        //adding query params to url
        urlComp.queryItems = [locationURLQuery, dateURLQuery, includeFielsURLQuery]
        
        //creating url
        guard let url = urlComp.url else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
           let measures = self.processMeasures(data, response, error)
                    
            completion(measures)
            
        }
        
        task.resume()
    }
    
    //MARK: Auxiliar functions
    
    
    fileprivate func processMeasures(_ data :Data?,_ response: URLResponse?,_ error: Error?)->[Measure]?  {
        
        var measureList:[Measure]? = nil
        
        if (error == nil && data != nil) {
            do {
                let measuresJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                measureList = parseMeasures(measuresJSON)
            } catch {
                //Error - Keep list as nil
            }
        }
        
        return measureList
        
    }
    
    
    
    //MARK: - Measure parsing methods
    
    
    /// Parse a list of measurement events
    ///
    /// - Parameter json: JSON fragment containgin the list of measurement events
    /// - Returns: List of air quality measurement events
    fileprivate func parseMeasures(_ json:Any) -> [Measure]? {
        
        var measures = [Measure]()
        
        if let rootElement = json as? NSDictionary {
            
            //getting results
            let results = rootElement["results"] as? [NSDictionary]
                
            if let lastResult = results?.first {
                
                if let measuresData = lastResult["measurements"] as? NSArray {
                    for measureData in measuresData {
                        if let measure = parseMeasure(measureData) {
                            measures.append(measure)
                        }
                    }
                }
            }
        }
        
        return measures
    }
    
    
    /// Parse one measurement event from JSON
    ///
    /// - Parameter json: JSON fragment representing an air quality measurement
    /// - Returns: An Air Quality measurement, nil if information is erred or unavailable
    fileprivate func parseMeasure(_ json:Any) -> Measure? {
        
        if let measureData = json as? NSDictionary {
            
            let averagingPeriod = measureData["averagingPeriod"] as? NSDictionary
            
            if let measureDate = measureData["lastUpdated"] as? String,
                let parameterCode = measureData["parameter"] as? String,
                let parameterType = MeasureType(rawValue:parameterCode),
                let value = measureData["value"] as? Double,
                let unit = measureData["unit"] as? String,
                let averagingPeriodValue = averagingPeriod?["value"] as? Int,
                let averagingPeriodUnit = averagingPeriod?["unit"] as? String
                
            {
                if let formattedDate = self.dateFormatter.date(from: measureDate) {
                    return Measure(date: formattedDate, type: parameterType, value: value, unit: unit, averagingPeriodValue: averagingPeriodValue, averagingPeriodUnit: averagingPeriodUnit)
                }
            }
        }
        
        
        return nil
    }
    


}
