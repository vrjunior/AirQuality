//
//  FlagMapper.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class FlagMapper {
    
    
    /// Get the flag icon based on its ISO Code
    ///
    /// - Parameter code: iso code
    /// - Returns: Flag image, if code is valid, nil otherwise
    static func flagIcon(code: String?) -> UIImage? {
        
        let flagCodeNormalized = code?.lowercased() ?? ""
        
        let image = UIImage(named: flagCodeNormalized)
        
        return image
        
    }

}
