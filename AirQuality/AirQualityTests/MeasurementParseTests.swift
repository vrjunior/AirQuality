//
//  MeasurementParseTests.swift
//  AirQualityTests
//
//  Created by Valmir Junior on 09/03/18.
//  Copyright © 2018 BEPiD. All rights reserved.
//

import XCTest
@testable import AirQuality

class MeasureParseTests: XCTestCase {
    
    var services : OpenAQMeasureServices!
    
    override func setUp() {
        super.setUp()
        
        services = OpenAQMeasureServices()
    }
    
    override func tearDown() {
        
        services = nil
        
        super.tearDown()
    }
    
    func testParseMeasures() {
        
        let json = [
            "results" :
                [
                    ["location":"40LD01 -LAAKDAL",
                     "city":"Flanders",
                     "country":"BE",
                     "distance":8979122.816959895,
                     "measurements":[
                        [
                            "parameter":"no2",
                            "value":0.5,
                            "lastUpdated":"2017-07-20T22:00:00.000Z",
                            "unit":"µg/m³",
                            "sourceName":"EEA Belgium",
                            "averagingPeriod":
                                ["value":1,"unit":"hours"]
        
                        ]
                    ],
                     "coordinates":
                        [
                            "latitude":51.109978,
                            "longitude":5.004864
                        ]
                    ]
                ]
        ]
        
        if let result = services.parseMeasures(json) {
            XCTAssert(result.count > 0, "Cannot convert measures json")
        } else {
            XCTFail("Cannot convert measures json")
        }
        
    }
    
    func testParseMeasuresWithLessParams() {
        
        let json = [
            "results" :
                [
                    ["location":"40LD01 -LAAKDAL",
                     "city":"Flanders",
                     "country":"BE",
                     "distance":8979122.816959895,
                     "coordinates":
                        [
                            "latitude":51.109978,
                            "longitude":5.004864
                        ]
                    ]
            ]
        ]
        
        let result = services.parseMeasures(json)
        XCTAssert(result?.count == 0, "Cannot convert measures json")
        
    }

    
}
