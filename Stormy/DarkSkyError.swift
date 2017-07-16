//
//  DarkSkyError.swift
//  Stormy
//
//  Created by Ty Schenk on 7/15/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

enum DarkSkyError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidURL
    case jsonParsingFailure
}
