//
//  MainViewController.swift
//  WheatherApp
//
//  Created by Neha Gupta on 03/05/21.
//

import UIKit
import CoreLocation
import GooglePlaces

class MainViewController: UIViewController {

    @IBOutlet weak var table:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var activityLoader:UIActivityIndicatorView!
    
    var mvWeatherResponse:MainViewModel!
    let locationManager = CLLocationManager()
    var currentLoaction:CLLocation?
    
    //Google Place API
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientView()
        searchBar.delegate = self
        activityLoader.isHidden = true
        table.isHidden = true
        table.backgroundColor = UIColor.clear
        requestWeatherForLoaction()
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpLocation()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if mvWeatherResponse != nil  {
            return 4
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mvWeatherResponse != nil {
            switch (section) {
                case 0,1,2: /* City details, Today ForeCast, Hourly Forecast */
                    return 1
                case 3: /* Time wise temperature */
                    return  mvWeatherResponse.weather.daily.count
            default:
                return 1
            }
        }else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CityDetailsTableViewCell.identifier, for: indexPath) as! CityDetailsTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.lblCityName.text = mvWeatherResponse.city != nil  && mvWeatherResponse.city.count > 0 ? mvWeatherResponse.city! : "Mumbai"
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            cell.lblCurrentDate.text = dateFormatter.string(from: date)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TodayForecastTableViewCell.identifier, for: indexPath) as! TodayForecastTableViewCell
            //cell.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            cell.backgroundColor = UIColor.clear
            cell.configure(mainViewModel: mvWeatherResponse)
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            //cell.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            cell.backgroundColor = UIColor.clear
            cell.configure(with: mvWeatherResponse.weather.hourly)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            let dailyWeather = mvWeatherResponse.weather.daily[indexPath.row]
            cell.configuare(to: dailyWeather)
            //cell.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            tableView.estimatedRowHeight = 63
            return UITableView.automaticDimension
        }else if indexPath.section == 1 {
            return 250
        }else if indexPath.section == 3 {
            return 60
        }
        else {
            return 100
        }
    }
    
    
    func setGradientView() {
        let topColor:UIColor =  UIColor.blue.withAlphaComponent(0.2)
        let bottomColor:UIColor =  UIColor.blue.withAlphaComponent(0.5)
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors 
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.frame = self.view.bounds
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        //table.backgroundView = backgroundView
    }
}
//MARK: - Location
extension MainViewController: CLLocationManagerDelegate {
    
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        requestWeatherForLoaction()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty , currentLoaction == nil {
            currentLoaction = locations.first
            locationManager.stopUpdatingLocation()
            
            requestWeatherForLoaction()
           
        }
    }
    
    private func setCityNameFromCoordinates() {
        guard let exposedLocation = self.locationManager.location else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }
        self.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
//            if let country = placemark.country {
//                output = output + "\n\(country)"
//            }
//            if let state = placemark.administrativeArea {
//                output = output + "\n\(state)"
//            }
            if let town = placemark.locality {
                output = output + "\(town)"
            }
            print("City Name: \(output)")
            self.mvWeatherResponse.city = output
            }
        }

    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else {
                    print("*** Error in \(#function): \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let placemark = placemarks?[0] else {
                    print("*** Error in \(#function): placemark is nil")
                    completion(nil)
                    return
                }
            completion(placemark)
            }
    }
    
    func requestWeatherForLoaction() {
        guard let currentLoaction = currentLoaction else {
            print("No location found")
            return
        }
        let long = currentLoaction.coordinate.longitude
        let lat = currentLoaction.coordinate.latitude
        print("long: \(long) lat:  \(lat)")
        activityLoader.isHidden = false
        setCityNameFromCoordinates()
        mvWeatherResponse = MainViewModel()
        mvWeatherResponse.getWeatherFromLoaction(coordination: currentLoaction.coordinate, completionHandler: {status, error -> Void in
            if status {
                DispatchQueue.main.async {
                    self.table.isHidden = false
                    self.table.reloadData()
                    //self.setTableViewBackgroundGradient()
                    self.activityLoader.isHidden = true
                }
                
            }else {
                self.activityLoader.isHidden = true
                Toast.showToast(controller: self, message: error.description)
            }
        })
        
        
    }
}

//Mark: - Google Place Api
extension MainViewController : UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
    
    
    
    func setUpPlaceApi() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                        UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityLoader.isHidden = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        activityLoader.isHidden = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setUpPlaceApi()
    }
}
