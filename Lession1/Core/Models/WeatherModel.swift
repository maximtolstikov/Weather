//
//  WeatherModel.swift
//  Lession1
//
//  Created by OIvanov on 06.03.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class WeatherModel: Object {
    @objc dynamic var date = 0.0
    @objc dynamic var temp = 0.0
    @objc dynamic var pressure = 0.0
    @objc dynamic var humidity = 0.0
    @objc dynamic var weatherName = ""
    @objc dynamic var weatherIcon = ""
    @objc dynamic var windSpeed = 0.0
    @objc dynamic var windDeg = 0.0
    @objc dynamic var city = ""

    convenience init(json: JSON, city: String) {
        self.init()
        
        date = json["dt"].doubleValue
        temp = json["main"]["temp"].doubleValue
        pressure = json["main"]["pressure"].doubleValue
        humidity = json["main"]["humidity"].doubleValue
        weatherName = json["weather"][0]["main"].stringValue
        weatherIcon = json["weather"][0]["icon"].stringValue
        windSpeed = json["wind"]["speed"].doubleValue
        windDeg = json["wind"]["deg"].doubleValue
        
        self.city = city
    }
    
}


