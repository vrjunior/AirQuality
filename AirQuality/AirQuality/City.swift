//
//  City.swift
//  AirQuality
//
//  Created by Valmir Junior on 24/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

struct City {
    var name:String
    var country: Country
    
    init(name:String, country: Country) {
        self.name = name
        self.country = country
    }
}
