//
//  City.swift
//  Lession1
//
//  Created by OIvanov on 16.03.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
    @objc dynamic var name = ""
    let weathers = List<WeatherModel>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
