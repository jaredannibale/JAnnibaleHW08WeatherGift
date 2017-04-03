//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Jared Annibale on 3/26/17.
//  Copyright © 2017 Jared Annibale. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = -999.99
    var dailySummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("Temp inside getWeather = \(temperature)")
                    self.currentTemp = temperature
                } else {
                    print("Could not return a temperature.")
                }
                if let summary = json["daily"]["summary"].string {
                    print("SUMMARY = \(summary)")
                    self.dailySummary = summary
                } else {
                    print("Could not return a temperature.")
                }
                if let icon = json["currently"]["icon"].string {
                    print("ICON = \(icon)")
                    self.currentIcon = icon
                } else {
                    print("Could not return a temperature.")
                }
                if let time = json["currently"]["time"].double {
                    print("Time inside getWeather = \(time)")
                    self.currentTime = time
                } else {
                    print("Could not return a time.")
                }
                if let timeZone = json["timezone"].string {
                    print("Time Zone = \(timeZone)")
                    self.timeZone = timeZone
                } else {
                    print("Could not return a time zone.")
                }
            case .failure(let error):
                print(error)
            }
            
            completed()
        }
        
    }
    
}
