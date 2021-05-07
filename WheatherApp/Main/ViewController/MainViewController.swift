//
//  MainViewController.swift
//  WheatherApp
//
//  Created by Neha Gupta on 03/05/21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var table:UITableView!
    
    var modals = [WeatherResponse]()
    let locationManager = CLLocationManager()
    var currentLoaction:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(HourlyCollectionViewCell.nib(), forCellReuseIdentifier: HourlyCollectionViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpLocation()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
//MARK: - Location
extension MainViewController: CLLocationManagerDelegate {
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty , currentLoaction == nil {
            currentLoaction = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLoaction()
        }
    }
    
    func requestWeatherForLoaction() {
        guard let currentLoaction = currentLoaction else {
            return
        }
        let long = currentLoaction.coordinate.longitude
        let lat = currentLoaction.coordinate.latitude
        print("long: \(long) lat:  \(lat)")
    }
}
