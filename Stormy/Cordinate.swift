//
//  Cordinate.swift
//  Stormy
//
//  Created by Ty Schenk on 7/15/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

struct Cordinate {
    let latitude: Double
    let longitude: Double
}

extension Cordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
}
