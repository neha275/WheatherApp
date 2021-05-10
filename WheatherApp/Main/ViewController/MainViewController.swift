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
    
    var modals = [WeatherResponse]()
    let locationManager = CLLocationManager()
    var currentLoaction:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPlaceApi()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        let dailyWeather = modals[0].daily[indexPath.row]
        cell.configuare(to: dailyWeather)
        
        return cell
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
        //let mvModel : MainViewModel = MainViewModel()
        
    }
}
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
}
