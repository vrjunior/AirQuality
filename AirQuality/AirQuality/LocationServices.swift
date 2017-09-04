//
//  LocationServices.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

protocol LocationServices {
    
    
     /// Retrieve locations (just from Campinas)
     ///
     /// - Parameter completion: completion handler, that receives a list of locations in Campinas-SP
    func retrieveLocations(city: City, completion:@escaping ([Location]?) -> Void)
    

    var measureServices:MeasurementServices? { get set }

}
