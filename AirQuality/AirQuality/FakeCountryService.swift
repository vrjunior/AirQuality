//
//  FakeCountryService.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class FakeCountryService: CountryServices {
    
    
    
    let countries = [Country(name:"Brazil", code:"BR"),Country(name:"Chile", code:"CL") ,Country(name:"China", code:"CN"), Country(name:"Mongolia", code:"MN"),Country(name:"Nepal", code:"NP"), Country(name:"Tanzania", code:"TZ")]
    
    
    func retrieveCoutries(completion:@escaping ([Country]?) -> Void) {
        completion(countries)
    }


}
