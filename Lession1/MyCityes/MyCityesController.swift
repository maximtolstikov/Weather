//
//  MyCityesController.swift
//  Lession1
//
//  Created by OIvanov on 27.02.2018.
//  Copyright © 2018 mkb. All rights reserved.
//

import UIKit
import RealmSwift

class MyCityesController: UITableViewController {

    var token: NotificationToken?
    var cityes: Results<City>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Мои города"
        
        pair()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeathers", let cell = sender as? UITableViewCell {
            let ctrl = segue.destination as! WeatherController
            if let indexPath = tableView.indexPath(for: cell) {
                ctrl.cityName = cityes?[indexPath.row].name ?? ""
            }
        }
    }
    
    private func pair() {
        guard let realm = try? Realm() else { return }
        cityes = realm.objects(City.self)
        
        token = cityes?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    @IBAction func addCityAction(_ sender: Any) {
        let alert = UIAlertController(title: "Введите имя города", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        let addAction = UIAlertAction(title: "Добавить", style: .default) { action in
            guard let name = alert.textFields![0].text else{ return }
            self.addCity(name)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func addCity(_ name: String) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            let city = City()
            city.name = name
            realm.add(city)
            try realm.commitWrite()
        } catch {
            print("Saved error: \(error)")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCityesCell", for: indexPath) as? MyCityesCell {
            var text = "Не определено"
            if let cityes = self.cityes, indexPath.row < cityes.count {
                let city = cityes[indexPath.row]
                text = city.name
            }
            cell.nameLabel.text = text
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // удаления записи
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let cityes = self.cityes, indexPath.row < cityes.count {
            do {
                let city = cityes[indexPath.row]
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(city.weathers)
                realm.delete(city)
                try realm.commitWrite()
            } catch {
                print("Saved error: \(error)")
            }
        }
    }

}
