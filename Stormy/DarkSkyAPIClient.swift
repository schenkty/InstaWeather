//
//  DarkSkyAPIClient.swift
//  Stormy
//
//  Created by Ty Schenk on 7/15/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

class DarkSkyAPIClient {
    
    
    // MARK: CHANGE THIS API KEY
    fileprivate let apiKey = "b853321513ee430a225b12b5f02b8dd7"
    
    lazy var baseUrl: URL = {
       return URL(string: "https://api.darksky.net/forecast/\(self.apiKey)/")!
    }()

    let downloader = JSONDownloader()
    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, DarkSkyError?) -> Void
    
    func getCurrentWeather(at cordinate: Cordinate, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        // MARK: URL Debug
        //print("https://api.darksky.net/forecast/\(self.apiKey)/\(cordinate.description)")
        guard let url = URL(string: cordinate.description, relativeTo: baseUrl) else {
            completion(nil, .invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else{
                    completion(nil, error)
                    return
                }
                
                guard let currentWeatherJson = json["currently"] as? [String: AnyObject], let currentWeather = CurrentWeather(json: currentWeatherJson) else {
                    completion(nil, .jsonParsingFailure)
                    return
                }
                
                completion(currentWeather, nil)
            }
        }
        
        task.resume()
    }
}
