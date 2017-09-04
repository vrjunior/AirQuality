//
//  CityServicers.swift
//  AirQuality
//
//  Created by Valmir Junior on 24/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

protocol CityServices {
    
    func retrieveCities(byCountry country: Country, completion: @escaping ([City]?) -> Void)
}
