//
//  TodayViewController.swift
//  TodayWeather
//
//  Created by OIvanov on 07.04.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults(suiteName: "group.ru.mkb.Lession1")
        if let icon = defaults?.string(forKey: "icon") {
            imageView.image = UIImage(named: icon)
        }
        if let city = defaults?.string(forKey: "city"), let temp = defaults?.string(forKey: "temp"){
            tempLabel.text = "\(city) \(temp)C"
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func gotoWeather(_ sender: Any) {
        if let url = URL(string: "weather://show") {
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }
    
}
