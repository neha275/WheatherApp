//
//  MainViewModel.swift
//  WheatherApp
//
//  Created by Neha Gupta on 07/05/21.
//

import UIKit
import CoreLocation

class MainViewModel  {
    
    var weather = WeatherResponse.empty()
    var city: String! // = {
//        didSet{
//            print("city Name ")
//        }
//
//    }
    
    private lazy var dateFormatter : DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private lazy var dayFormatter :DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private lazy var timeFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        return formatter
    }()
    
//    init() {
//        getLoacation()
//    }
    
    var date:String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.dt)))
    }
    
    var weatherIcon: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return "sun.max.fill"
    }
    
    var temperature: String {
        return getTempFor(temp: weather.current.temp)
    }
    
    func getTempFor(temp: Double) -> String {
        let temp = String(format: "%0.1f", temp)
        return "\(temp) ℉"
    }
    
    
    var condition: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].main
        }
        return ""
    }
    
    var windSped:String {
        return String(format: "%0.1f", weather.current.wind_speed)
    }
    
    var humidity: String {
        return String(format: "%d%", weather.current.humidity)
    }
    
    var rainChance: String {
        return String(format: "%0.1f%", weather.current.dew_point)
    }
    
    func gettimeFor(timestamp: Int)-> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func getDayFor(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dayFormatter.string(from: date)
    }
    
    func getLoacationCoordinateFromCityName()   {
        CLGeocoder().geocodeAddressString(city, completionHandler: {(placeMarks, error) in
            if let places = placeMarks, let place = places.first {
                //self.getWeather(coordination: place.location?.coordinate)
                print(place)
            }
            
        })
    }
    
    func getWeatherFromLoaction(coordination: CLLocationCoordinate2D,completionHandler: @escaping (Bool,String) -> Void)  {
        let urlString = API.getURLFor(lat: coordination.latitude, lon: coordination.longitude)
        getWeatherInternal(city: city, for: urlString, completionHandler: { status, error, response -> Void  in
            if status {
                self.weather = response!
                return completionHandler (true,String())
            }else {
                return completionHandler(false,error)
            }
        })
    }
    
//    private func getWeather(coordination : CLLocationCoordinate2D?) {
//        if let coordination = coordination {
//            let urlString = API.getURLFor(lat: coordination.latitude, lon: coordination.longitude)
//            getWeatherInternal(city: city, for: urlString, completionHandler: <#(Bool, String) -> Void#>)
//        }else {
//            let urlString = API.getURLFor(lat: 37.5485, lon: -121.9886)
//            getWeatherInternal(city: city, for: urlString, completionHandler: <#(Bool, String) -> Void#>)
//        }
//    }
    
    private func getWeatherInternal(city: String?, for urlString: String, completionHandler: @escaping (Bool,String, WeatherResponse?) -> Void) {
        NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!, completion: {result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
                completionHandler(true,String(), response)
                break
            case .failure(let err):
                print(err)
                completionHandler(false,err.localizedDescription, nil)
            }
        })
    }
    
    func getWeatherIconFor(icon: String) ->  UIImage{
        switch  icon {
        case "01d":
            return UIImage(systemName: "sun.max.fill")!
        case "01n":
            return UIImage(systemName: "moon.fill")!
        case "02d":
            return UIImage(systemName: "cloud.sun.fill")!
        case "02n":
            return UIImage(systemName: "cloud.moon.fill")!
        case "03d":
            return UIImage(systemName: "cloud.fill")!
        case "03n":
            return UIImage(systemName: "cloud.fill")!
        case "04d":
            return UIImage(systemName: "cloud.fill")!
        case "04n":
            return UIImage(systemName: "cloud.fill")!
        case "09d":
            return UIImage(systemName: "cloud.drizzle.fill")!
        case "09n":
            return UIImage(systemName: "cloud.drizzle.fill")!
        case "10d":
            return UIImage(systemName: "cloud.heavyrain.fill")!
        case "10n":
            return UIImage(systemName: "cloud.heavyrain.fill")!
        case "11d":
            return UIImage(systemName: "cloud.bolt.fill")!
        case "11n":
            return UIImage(systemName: "cloud.bolt.fill")!
        case "13d":
            return UIImage(systemName: "cloud.snow.fill")!
        case "13n":
            return UIImage(systemName: "cloud.fog.fill")!
        case "50d":
            return UIImage(systemName: "cloud.fog.fill")!
        case "50n":
            return UIImage(systemName: "cloud.snow.fill")!
        default:
            return UIImage(systemName: "sun.max.fill")!
        }
    }
}


