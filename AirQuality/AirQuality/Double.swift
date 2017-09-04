//
//  Double.swift
//  AirQuality
//
//  Created by Valmir Junior on 31/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
