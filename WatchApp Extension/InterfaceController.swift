//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by OIvanov on 13.04.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var imageInterface: WKInterfaceImage!
    @IBOutlet weak var cityLabelInterface: WKInterfaceLabel!
    @IBOutlet weak var temperatureLabelInterface: WKInterfaceLabel!
    
    var session: WCSession?
    var defaults = UserDefaults.standard
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func update() {
        cityLabelInterface.setText(defaults.value(forKey: "city") as? String)
        temperatureLabelInterface.setText(defaults.value(forKey: "temperature") as? String)
        imageInterface.setImageNamed(defaults.value(forKey: "image") as? String)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            update()
            session.sendMessage(["request":"weather"], replyHandler: { (reply) in
                self.defaults.set(reply["city"], forKey: "city")
                self.defaults.set(reply["temperature"], forKey: "temperature")
                self.defaults.set(reply["image"], forKey: "image")
                self.update()
            }, errorHandler: { (error) in
                self.cityLabelInterface.setText("Невозможно получить данные")
            })
        } else {
            cityLabelInterface.setText("Невозможно получить данные")
        }
    }

}
