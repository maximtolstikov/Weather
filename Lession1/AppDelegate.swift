//
//  AppDelegate.swift
//  Lession1
//
//  Created by OIvanov on 10.01.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var window: UIWindow?
    let service = WeatherService()
    let manager = ManagerData()
    var session: WCSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("CountFetch: \(UserDefaults.standard.integer(forKey: "CountFetch"))")
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let count = UserDefaults.standard.integer(forKey: "CountFetch")
        UserDefaults.standard.set(count + 1, forKey: "CountFetch")
        
        print("Start performFetchWithCompletionHandler...")
        
        let names = manager.loadCityNames()
        for name in names {
            fetchCitiesWeatherGroup.enter()
            service.loadWeather(city: name)
        }
        fetchCitiesWeatherGroup.notify(queue: DispatchQueue.main) {
            print ("Все данные загружены в фоне")
            completionHandler(.newData)
            return
        }
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let text = url.host?.removingPercentEncoding
        print(" --- HandleOpen - \(text ?? "")")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

    /*
     Сообщения могут быть отправлены и получены только в том случае, если оба процесса активны и работают.
     Доставка нескольких сообщений происходит последовательно, поэтому ваша реализация этого метода не требует повторного ввода. Этот метод называется фоновым потоком вашего приложения.
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Swift.Void) {

        if message["request"] as? String == "weather" {
            replyHandler(["temperature":"-4 °C", "image": "13n", "city": "Москва"])
        }
    }

}
