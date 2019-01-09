//
//  ManagerData.swift
//  Lession1
//
//  Created by OIvanov on 28.03.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import Foundation
import RealmSwift

class ManagerData {
    
    func loadCityNames() -> [String] {
        guard let realm = try? Realm() else { return [String]()}

        var result = [String]()
        let cities = realm.objects(City.self)
        for citiy in cities {
            result.append(citiy.name)
        }
        return result
    }
    
    func save(_ weathers: [WeatherModel], _ cityName: String) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            print(realm.configuration.fileURL ?? "")
            
            guard let city = realm.object(ofType: City.self, forPrimaryKey: cityName) else { return }
            let oldWeathers = city.weathers
            
            realm.beginWrite()
            realm.delete(oldWeathers)
            city.weathers.append(objectsIn: weathers)
            try realm.commitWrite()
            
//            fetchCitiesWeatherGroup.leave()
            
            let defaults = UserDefaults(suiteName: "group.ru.mkb.Lession1")
            defaults?.set(weathers[0].city, forKey: "city")
            defaults?.set(weathers[0].temp, forKey: "temp")
            defaults?.set(weathers[0].weatherIcon, forKey: "icon")
            defaults?.synchronize()
        } catch {
            print("Saved error: \(error)")
        }
    }

}
