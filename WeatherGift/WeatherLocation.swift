//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Jared Annibale on 3/26/17.
//  Copyright © 2017 Jared Annibale. All rights reserved.
//

import Foundation
import Alamofire

class WeatherLocation {
    var name = ""
    var coordinates = ""
    
    func getWeather() {
        let weatherURL = urlBase + urlAPIKey + coordinates
        print(weatherURL)
        
        Alamofire.request(weatherURL).responseJSON{ response in
            print(response)
        }
    }
}

