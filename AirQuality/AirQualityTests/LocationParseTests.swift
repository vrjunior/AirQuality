//
//  LocationParseTests.swift
//  AirQualityTests
//
//  Created by Valmir Junior on 09/03/18.
//  Copyright © 2018 BEPiD. All rights reserved.
//

import XCTest
@testable import AirQuality

class LocationParseTests: XCTestCase {
    
    var services : OpenAQLocationServices!
    
    override func setUp() {
        super.setUp()
        
        services = OpenAQLocationServices()
    }
    
    override func tearDown() {
        
        services = nil
        
        super.tearDown()
    }
    
    func testParseLocations() {
        
        let json = ["results" :[
                [
                    "count": 4242,
                    "sourceName": "Australia - New South Wales",
                    "firstUpdated": "2015-10-13T01:00:00.000Z",
                    "lastUpdated": "2015-11-14T03:00:00.000Z",
                    "parameters": [
                        "pm25",
                        "pm10",
                        "so2",
                        "co",
                        "no2",
                        "o3"
                    ],
                    "country": "AU",
                    "city": "Central Coast",
                    "location": "Wyong"
            
                ],
                [
                    "count": 728,
                     "sourceName": "Australia - New South Wales",
                     "firstUpdated": "2015-10-13T01:00:00.000Z",
                     "lastUpdated": "2015-11-14T03:00:00.000Z",
                     "parameters": [
                        "pm10"
                        ],
                     "country": "AU",
                     "city": "Central Tablelands",
                     "location": "Bathurst"
                ]
            
            ]
        ]
        
        let country = Country(name: "Brazil", code: "BR")
        let city = City(name: "Campinas", country: country)
        
        if let result = services.parseLocations(json, city: city) {
            XCTAssert(result.count > 0, "Cannot parse locations json")
        }
        else {
            XCTFail("Cannot parse locations json")
        }
        
    }
    
    func testParseLocationsWithLessParams() {
        
        let json = ["results" :[
            [
                "count": 4242,
                "sourceName": "Australia - New South Wales",
                "firstUpdated": "2015-10-13T01:00:00.000Z",
                "lastUpdated": "2015-11-14T03:00:00.000Z",
                "parameters": [
                    "pm25",
                    "pm10",
                    "so2",
                    "co",
                    "no2",
                    "o3"
                ],
                "country": "AU",
                "city": "Central Coast",
                
            ]
            
            ]
        ]
        
        let country = Country(name: "Brazil", code: "BR")
        let city = City(name: "Campinas", country: country)
        
        let result = services.parseLocations(json, city: city)
        
        XCTAssert(result?.count == 0, "Cannot parse locations json")

    }
    
}
