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
    @IBOutlet weak var searchBar:UISearchBar!
    
    var mvWeatherResponse:MainViewModel!
    let locationManager = CLLocationManager()
    var currentLoaction:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            //setUpPlaceApi()
        table.register(HourlyCollectionViewCell.nib(), forCellReuseIdentifier: HourlyCollectionViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpLocation()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            case 0,1,2: /* City details, Today ForeCast, Hourly Forecast */
                return 1
            case 3: /* Time wise temperature */
            return mvWeatherResponse.weather.daily.count
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CityDetailsTableViewCell.identifier, for: indexPath) as! CityDetailsTableViewCell
            cell.lblCityName.text = mvWeatherResponse.city
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            cell.lblCurrentDate.text = dateFormatter.string(from: date)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TodayForecastTableViewCell.identifier, for: indexPath) as! TodayForecastTableViewCell
            cell.configure(mainViewModel: mvWeatherResponse)
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            let dailyWeather = mvWeatherResponse.weather.daily[indexPath.row]
            cell.configuare(to: dailyWeather)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        mvWeatherResponse = MainViewModel()
        mvWeatherResponse.getWeatherFromLoaction(coordination: currentLoaction.coordinate, completionHandler: {status, error -> Void in
            if status {
                self.table.reloadData()
            }else {
                print(error)
            }
        })
        
        
    }
}
/*
//MArk: - Google Place Api
extension MainViewController : UISearchBarDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    func setUpPlaceApi() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController

        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true

        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
      }

      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
      }

      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
}*/
