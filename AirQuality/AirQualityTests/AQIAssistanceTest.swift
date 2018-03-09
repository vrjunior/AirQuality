//
//  AQIAssistanceTest.swift
//  AirQualityTests
//
//  Created by Valmir Junior on 08/03/18.
//  Copyright © 2018 BEPiD. All rights reserved.
//

import XCTest
@testable import AirQuality

class AQIAssistanceTest: XCTestCase {
    
    var assistance: AQIAssistance!
    
    override func setUp() {
        super.setUp()
        
        assistance = AQIAssistance()
    }
    
    override func tearDown() {
        assistance = nil
        
        super.tearDown()
    }
    
    func testAQIcalc() {
        let measure = Measure(date: Date(), type: .carbonMonoxide, value: 300, unit: "ppm", averagingPeriodValue: 1, averagingPeriodUnit: "day")
        
        let result = assistance.calcAQI(measure: measure)

        XCTAssert(result == .good, "errouu")
    }
    
}
