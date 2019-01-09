//
//  WeatherCell.swift
//  Lession1
//
//  Created by OIvanov on 27.02.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy HH:mm"
        return df
    }()
    
    func configure(_ weather: WeatherModel) {
        let date = Date(timeIntervalSince1970: weather.date)
        timeLabel.text = WeatherCell.dateFormatter.string(from: date)

        weatherLabel.text = "\(weather.temp)"
        icon.image = UIImage(named: weather.weatherIcon)
    }
    
}
