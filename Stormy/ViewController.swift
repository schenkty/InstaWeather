//
//  ViewController.swift
//  Stormy
//
//  Created by Pasan Premaratne on 2/15/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityName: UILabel!
    
    let client = DarkSkyAPIClient()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Display Weather
    func displayWeather(using viewModel: CurrentWeatherViewModel) {
        currentTemperatureLabel.text = viewModel.temperature
        currentHumidityLabel.text = viewModel.humidity
        currentPrecipitationLabel.text = viewModel.precipitationProbability
        currentSummaryLabel.text = viewModel.summary
        currentWeatherIcon.image = viewModel.icon
    }
    
    @IBAction func getCurrentWeather() {
        toggleRefreshAnimation(on: true)
        determineMyCurrentLocation()
        getAddressFromGeocodeCoordinate(locationObj: locationManager.location!)
        
        // MARK: Adjust cords here. pls update with user's loc and loc name
        let cordinate = Cordinate(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        client.getCurrentWeather(at: cordinate) { [unowned self] currentWeather, error in
            if let currentWeather = currentWeather {
                let viewModel = CurrentWeatherViewModel(model: currentWeather)
                self.displayWeather(using: viewModel)
                self.toggleRefreshAnimation(on: false)
            }
        }
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton.isHidden = on
        
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        showAlert(title: "Can not find user location")
    }
    
    func getAddressFromGeocodeCoordinate(locationObj: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationObj, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var endCode: String = ""
            var cityNameString: String = ""
            var countryCode: String = ""
            var stateCode: String = ""
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary - Use to find new data to work with
            //print(placeMark.addressDictionary!)
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                cityNameString = city
            }
            
            // State Code
            if let state = placeMark.addressDictionary!["State"] as? String {
                stateCode = state
            }
            
            // Country Code
            if let country = placeMark.addressDictionary!["CountryCode"] as? String {
                countryCode = country
            }
            
            if countryCode == "US" {
                endCode = stateCode
            } else {
                endCode = countryCode
            }
            
            self.cityName.text = "\(cityNameString), \(endCode)"
        })
    }
    
    // Function to add alerts for invalid data
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
