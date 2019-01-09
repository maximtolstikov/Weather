//
//  WeatherService.swift
//  Lession1
//
//  Created by OIvanov on 02.03.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class WeatherService {
    // http://samples.openweathermap.org/data/2.5/forecast?q=Moscow,DE&appid=b1b15e88fa797225412429c1c50c122a1
    let baseUrl = "http://samples.openweathermap.org/data/2.5/forecast"
    let apiKey = "b1b15e88fa797225412429c1c50c122a1"
    
    let managerData = ManagerData()
    
    func loadWeather(city: String) {
        let params: Parameters = [
            "q" : city,
            "appid" : apiKey
        ]
        
        Alamofire.request(baseUrl, parameters: params).responseData{ [weak self] response in
            guard let weakSelf = self, let data = response.value else {
                print("Wrong response")
                return
            }
            
            if let json = try? JSON(data: data) {
                let weathers: [WeatherModel] = json["list"].map {WeatherModel(json: $0.1, city: city)}
                weakSelf.managerData.save(weathers, city)
            } else {
                print("Wrong json")
            }
        }
    }
    
}
