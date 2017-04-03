//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Jared Annibale on 3/19/17.
//  Copyright © 2017 Jared Annibale. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentPage == 0 {
            getLocation()
        }
        
        locationManager.delegate = self
        locationsArray[currentPage].getWeather {
            self.updateUserInterface()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if currentPage == 0 {
            getLocation()
        }
    }

    
    func updateUserInterface() {
        
        let isHidden = (locationsArray[currentPage].currentTemp == -999.99)
        
        temperatureLabel.isHidden = isHidden
        locationLabel.isHidden = isHidden
        
        locationLabel.text = locationsArray[currentPage].name
        dateLabel.text = formatTimeForTimeZone(unixDateToFormat: locationsArray[currentPage].currentTime, timeZoneString: locationsArray[currentPage].timeZone)
        
        let curTemperature = String(format: "%3.f", locationsArray[currentPage].currentTemp) + "°"
        temperatureLabel.text = curTemperature
        
        summaryLabel.text = locationsArray[currentPage].dailySummary
        
        currentImage.image = UIImage(named: locationsArray[currentPage].currentIcon)
    }
    
    func formatTimeForTimeZone(unixDateToFormat: TimeInterval, timeZoneString: String) -> String {
        let usableDate = Date(timeIntervalSince1970: unixDateToFormat)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM. dd, y"
        dateFormatter.timeZone = TimeZone(identifier: timeZoneString)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
    
}

extension DetailVC: CLLocationManagerDelegate{
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        handleLocationAuthorizationStatus(status: status)
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied:
            print("Use has not authorized location")
        case .restricted:
            print("Access denied - likely parental controls are restricting location use.")
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentPage == 0 {
            
            let geoCoder = CLGeocoder()
           
            currentLocation = locations.last
            
            let currentLat = "\(currentLocation.coordinate.latitude)"
            let currentLong = "\(currentLocation.coordinate.longitude)"
            
            print("Coordinates are " + currentLat + currentLong)
            
            
            var place = ""
            
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {placemarks, error in
                if placemarks != nil {
                    let placemark = placemarks!.last
                    place = (placemark?.name!)!
                } else {
                    print("Error retrieving place. Error code: \(error!)")
                    place = "Parts Unknown."
                }
                print(place)
                self.locationsArray[0].name = place
                self.locationsArray[0].coordinates = currentLat + "," + currentLong
                self.locationsArray[0].getWeather {
                    self.updateUserInterface()
                }
            })
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error Getting Location - Error Code \(error)")
    }
}
