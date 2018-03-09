//
//  AirQualityTests.swift
//  AirQualityTests
//
//  Created by Valmir Junior on 07/03/18.
//  Copyright © 2018 BEPiD. All rights reserved.
//

import XCTest
@testable import AirQuality

class CountriesParseTests: XCTestCase {
    
    var countryService: OpenAQCountryServices!
    
    override func setUp() {
        super.setUp()
        countryService = OpenAQCountryServices()
    }
    
    override func tearDown() {

        countryService = nil
        
        super.tearDown()
    }
    
    func testCountriesJSONParse() {
        
        let json = ["results" : [
                ["count": 40638,
                "code": "AU",
                "name": "Australia"],
                ["count": 78681,
                 "code": "BR",
                 "name": "Brazil"]
            ]
        ]
        let result = countryService.parseCountries(json)
        
        
        if let result = result {
            XCTAssert(result.count > 0, "Countries JSON cannot be parsed")
        }
        else {
            XCTFail("Countries JSON cannot be parsed")
        }
        
    }
    
    func testCountryJSONParseWithLessParms() {
        
        
        let json: Any = [
            "code": "AU"
        ]
        
        let result = countryService.parseCountry(json)
        
        XCTAssert(result == nil, "Contries JSON shouldn't be parsed")
        
    }
    
    
}
