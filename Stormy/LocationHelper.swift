//
//  LocationHelper.swift
//  InstaWeather
//
//  Created by Ty Schenk on 7/16/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import MapKit

typealias JSONDictionary = [String:Any]

class LocationServices {
    
    let shared = LocationServices()
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    
    func getAdress(completion: @escaping (_ address: JSONDictionary?, _ error: Error?) -> ()) {
        
        self.locManager.requestWhenInUseAuthorization()
        
        if self.authStatus == inUse || self.authStatus == always {
            
            self.currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
                
                if let e = error {
                    
                    completion(nil, e)
                    
                } else {
                    
                    let placeArray = placemarks
                    
                    var placeMark: CLPlacemark!
                    
                    placeMark = placeArray?[0]
                    
                    guard let address = placeMark.addressDictionary as? JSONDictionary else {
                        return
                    }
                    
                    completion(address, nil)
                    
                }
            }
        }
    }
}
