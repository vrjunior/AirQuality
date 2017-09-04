//
//  AQIAssistance.swift
//  AirQuality
//
//  Created by Valmir Junior on 31/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation


enum AQILevel : Int, CustomStringConvertible {
    case good = 1
    case moderate = 2
    case unhealthy = 3
    case veryUnhealthy = 4
    case hazardous = 5
    
    var description: String {
        switch self {
        case .good:
            return "Bom"
    
        case .moderate:
            return "Regular"
            
        case .unhealthy:
            return "Inadequada"
            
        case .veryUnhealthy:
            return "Má"
            
        case .hazardous :
            return "Pessima"
        }
    }
    
}

struct ConcentrationBreakpoint {
    var low: Double
    var high: Double
}

struct AQIIndexBreakpoint {
    var low: Double
    var high: Double
}

class AQIAssistance {
    
    
    func getAqiIndexes(measures: [Measure]) -> [(MeasureType, AQILevel)] {
        
        var result = [(MeasureType, AQILevel)]()
        
        for measure in measures {
            
            if let level = self.calcAQI(measure: measure) {
                
                result.append((measure.type, level))
                
            }
            
        }
        
        return result.sorted(by: { $0.1.rawValue > $1.1.rawValue })
        
    }
    
    
    func calcAQI(measure: Measure) -> AQILevel? {
        
        if let breakpoints = self.getBreakpoint(byMeasure: measure) {
            
            let i = breakpoints.0
            let c = breakpoints.1
            
            let cMedium = measure.value
            
            //applying formula
            let index = ((i.high - i.low) / (c.high - c.low)) * (cMedium - c.low) + i.low
            
            
            return self.getAQILevel(index: index)
            
        }
        
        return nil

    }
    
    
    func convertToPPM(fromMgM3 mgm3:Double) -> Double {
        return mgm3/1000
    }
    
    func convertToMgM3(fromPPM ppm:Double) -> Double {
        return ppm * 1000
    }
    
    //just to remember me that mgm3 is equal to ppb
    func convertToPPB(fromMgM3 mgm3:Double) -> Double {
        return mgm3
    }
    
    func convertToMgM3(fromPPB ppb: Double) -> Double {
        return ppb
    
    }
    
    
    fileprivate func getAQILevel(index: Double) -> AQILevel {
        
        if(index <= 50) {
            return .good
        }
        
        if(index <= 100) {
            return .moderate
        }
        
        if(index <= 200) {
            return .unhealthy
        }
        
        if(index <= 300) {
            return .veryUnhealthy
        }
        
        return .hazardous
    }
    
    fileprivate func getBreakpoint(byMeasure measure: Measure) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch measure.type {
            
            case .carbonMonoxide:
                
                //truncate to 1 decimal place
                //assuming that come as mgm3
                let coPPM = self.convertToPPM(fromMgM3: measure.value).rounded(toPlaces: 1)
                return self.getBreakpoint(byCoPPM: coPPM)
                
            case .ozone :
                //assuming that come as mgm3
                let o3MgM3 = measure.value
                return self.getBreakpoint(byO3MgM3: o3MgM3)
                
            case .nitrogenDioxide :
                //truncate to integer
                //assuming that come as mgm3
                let no2MgM3 = measure.value
                return self.getBreakpoint(byNo2MgM3: no2MgM3)
                
            case .particulateMatterLess10 :
                //assuming that comes as mgm3
                let pm10MgM3 = measure.value
                return self.getBreakpoint(byPm10MgM3: pm10MgM3)
                
            case .particulateMatterLess2_5 :
                //assuming that comes as mgm3
                let pm25MgM3 = measure.value
                return self.getBreakpoint(byPm25MgM3: pm25MgM3)
                
            case .sufurDiozide :
                //assuming that comes as mgm3
                let so2MgM3 = measure.value
                return self.getBreakpoint(bySo2MgM3: so2MgM3)
                
            default:
                return nil
            
        }
        
    }
    
    fileprivate func getBreakpoint(byO3MgM3 o3MgM3: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {

        switch o3MgM3 {
            case 0 ... 80:
                return(ConcentrationBreakpoint(low: 0, high: 80), AQIIndexBreakpoint(low: 0, high: 50))
                
            case 80...160 :
                return (ConcentrationBreakpoint(low: 80, high: 160), AQIIndexBreakpoint(low: 51, high: 100))
            
            case 160 ... 200:
                return(ConcentrationBreakpoint(low: 160, high: 200), AQIIndexBreakpoint(low: 101, high: 200))
                
            case 200 ... 800:
                return(ConcentrationBreakpoint(low: 200, high: 800), AQIIndexBreakpoint(low: 201, high: 300))
                
            case let o3MgM3 where o3MgM3 >= 800:
                return(ConcentrationBreakpoint(low: 800, high: o3MgM3), AQIIndexBreakpoint(low: 301, high: o3MgM3))
                
            default:
                return nil
        }
    }
    
    fileprivate func getBreakpoint(bySo2MgM3 so2MgM3: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch so2MgM3 {
            case 0 ... 80 :
                return(ConcentrationBreakpoint(low: 0, high: 80), AQIIndexBreakpoint(low: 0, high: 50))
                
            case 80...365 :
                return (ConcentrationBreakpoint(low: 80, high: 365), AQIIndexBreakpoint(low: 51, high: 100))
                
            case 365 ... 800 :
                return(ConcentrationBreakpoint(low: 360, high: 800), AQIIndexBreakpoint(low: 101, high: 200))
                
            case 800 ... 1600 :
                return(ConcentrationBreakpoint(low: 800, high: 1600), AQIIndexBreakpoint(low: 201, high: 300))
                
            case let so2MgM3 where so2MgM3 >= 1600:
                return(ConcentrationBreakpoint(low: 1600, high: so2MgM3), AQIIndexBreakpoint(low: 301, high: so2MgM3))
                
            default :
                return nil
        }
    }
    
    fileprivate func getBreakpoint(byCoPPM coPPM: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch coPPM {
        case 0 ... 4 :
            return(ConcentrationBreakpoint(low: 0, high: 4), AQIIndexBreakpoint(low: 0, high: 50))
            
        case 4 ... 9 :
            return (ConcentrationBreakpoint(low: 4, high: 9), AQIIndexBreakpoint(low: 51, high: 100))
            
        case 9 ... 15 :
            return(ConcentrationBreakpoint(low: 9, high: 15), AQIIndexBreakpoint(low: 101, high: 200))
            
        case 15 ... 30 :
            return(ConcentrationBreakpoint(low: 15, high: 30), AQIIndexBreakpoint(low: 201, high: 300))
            
        case let coPPM where coPPM >= 30:
            return(ConcentrationBreakpoint(low: 30, high: coPPM), AQIIndexBreakpoint(low: 301, high: coPPM))
            
        default :
            return nil
        }
    }
    
    fileprivate func getBreakpoint(byPm10MgM3 pm10MgM3: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch pm10MgM3 {
            case 0 ... 50 :
                return(ConcentrationBreakpoint(low: 0, high: 50), AQIIndexBreakpoint(low: 0, high: 50))
                
            case 50 ... 150 :
                return (ConcentrationBreakpoint(low: 50, high: 150), AQIIndexBreakpoint(low: 51, high: 100))
                
            case 150 ... 250 :
                return(ConcentrationBreakpoint(low: 150, high: 250), AQIIndexBreakpoint(low: 101, high: 200))
                
            case 250 ... 420 :
                return(ConcentrationBreakpoint(low: 250, high: 420), AQIIndexBreakpoint(low: 201, high: 300))
                
            case let pm10MgM3 where pm10MgM3 >= 420:
                return(ConcentrationBreakpoint(low: 420, high: pm10MgM3), AQIIndexBreakpoint(low: 420, high: pm10MgM3))
                
            default :
                return nil
        }
    }
    
    fileprivate func getBreakpoint(byPm25MgM3 pm25MgM3: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch pm25MgM3 {
        case 0 ... 25 :
            return(ConcentrationBreakpoint(low: 0, high: 25), AQIIndexBreakpoint(low: 0, high: 50))
            
        case 25 ... 50 :
            return (ConcentrationBreakpoint(low: 51, high: 150), AQIIndexBreakpoint(low: 51, high: 100))
            
        case 151 ... 250 :
            return(ConcentrationBreakpoint(low: 151, high: 250), AQIIndexBreakpoint(low: 101, high: 200))
            
        case 251 ... 420 :
            return(ConcentrationBreakpoint(low: 251, high: 420), AQIIndexBreakpoint(low: 201, high: 300))
            
        case let pm10MgM3 where pm10MgM3 >= 421:
            return(ConcentrationBreakpoint(low: 421, high: pm10MgM3), AQIIndexBreakpoint(low: 421, high: pm10MgM3))
            
        default :
            return nil
        }
    }
    
    
    
    fileprivate func getBreakpoint(byNo2MgM3 no2MgM3: Double) -> (ConcentrationBreakpoint, AQIIndexBreakpoint)? {
        
        switch no2MgM3 {
            case 0 ... 100 :
                return(ConcentrationBreakpoint(low: 0, high: 100), AQIIndexBreakpoint(low: 0, high: 50))
                
            case 101 ... 320 :
                return (ConcentrationBreakpoint(low: 101, high: 320), AQIIndexBreakpoint(low: 51, high: 100))
                
            case 321 ... 1130 :
                return(ConcentrationBreakpoint(low: 321, high: 1130), AQIIndexBreakpoint(low: 101, high: 200))
                
            case 1131 ... 2260 :
                return(ConcentrationBreakpoint(low: 1131, high: 2260), AQIIndexBreakpoint(low: 201, high: 300))
                
            case let no2MgM3 where no2MgM3 >= 2261:
                return(ConcentrationBreakpoint(low: 2261, high: no2MgM3), AQIIndexBreakpoint(low: 2261, high: no2MgM3))
                
            default :
                return nil
        }
    }
    
    
    
    
    
    
}
