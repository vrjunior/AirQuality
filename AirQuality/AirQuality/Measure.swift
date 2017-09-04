//
//  Measure.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation


enum MeasureType:String {
    
    case blackCarbon = "bc"
    case carbonMonoxide = "co"
    case nitrogenDioxide = "no2"
    case ozone="o3"
    case particulateMatterLess10 = "pm10"
    case particulateMatterLess2_5 = "pm25"
    case sufurDiozide="so2"
    
}

struct Measure {
    
    var date:Date
    var type:MeasureType
    var value:Double
    var unit:String
    
    var averagingPeriodValue: Int
    var averagingPeriodUnit: String
    
}
