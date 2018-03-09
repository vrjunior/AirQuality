//
//  CityParseTests.swift
//  AirQualityTests
//
//  Created by Valmir Junior on 08/03/18.
//  Copyright © 2018 BEPiD. All rights reserved.
//

import XCTest
@testable import AirQuality

class CityParseTests: XCTestCase {
    
    var services : OpenAQCityServices!
    
    override func setUp() {
        super.setUp()
        
        services = OpenAQCityServices()
    }
    
    override func tearDown() {
        
        services = nil
        
        super.tearDown()
    }
    
    func testCitiesParse() {
        
        let json: Any = ["results" : [
            [
                 "city": "Amsterdam",
                 "country": "BR",
                 "count": 21301,
                 "locations": 14
            ],
            [
                "city": "Badhoevedorp",
                "country": "BR",
                "count": 2326,
                "locations": 1
            ]
        ]
        ]
        
        let country = Country(name: "BR", code: "BR")
        let result = services.parseCities(json: json, country: country)
        
        XCTAssert(result != nil, "Failed to parse json")
    }
    
    func testCitiesParseWithLessParam() {
        let json: Any = ["results" :
            [
                [
                    "country": "BR",
                    "count": 21301,
                    "locations": 14
                ]
            ]
        ]
        let country = Country(name: "BR", code: "BR")
        let result = services.parseCities(json: json, country: country)
        
        XCTAssert(result?.count == 0, "Should not convert json")
    }
}
