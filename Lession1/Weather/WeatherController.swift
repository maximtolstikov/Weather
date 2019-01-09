//
//  WeatherController.swift
//  Lession1
//
//  Created by OIvanov on 27.02.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import UIKit
import RealmSwift

class WeatherController: UICollectionViewController {

    var cityName = ""
    let weatherService = WeatherService()

    var weathers: List<WeatherModel>!
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Погода"
        
        pair()
        weatherService.loadWeather(city: cityName)
    }

    private func pair() {
        guard let realm = try? Realm(), let city = realm.object(ofType: City.self, forPrimaryKey: cityName) else { return }
        
        weathers = city.weathers
        
        token = weathers.observe { [weak self] (changes: RealmCollectionChange) in



            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as? WeatherCell {

            if let weathers = self.weathers, indexPath.row < weathers.count {
                let weather = weathers[indexPath.row]
                cell.configure(weather)
            }

            return cell
        }
        return UICollectionViewCell()
    }

}
