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
    var city: String = "Mumbai" {
        didSet{
            getLoacation()
        }
    }
    
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
    
    init() {
        getLoacation()
    }
    
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
        return String(format: "%0.1f", temp)
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
    
    func getDayFor(timestamp: Int)-> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    private func getLoacation() {
        CLGeocoder().geocodeAddressString(city, completionHandler: {(placeMarks, error) in
            if let places = placeMarks, let place = places.first {
                self.getWeather(coordination: place.location?.coordinate)
            }
            
        })
    }
    
    private func getWeather(coordination : CLLocationCoordinate2D?) {
        if let coordination = coordination {
            let urlString = API.getURLFor(lat: coordination.latitude, lon: coordination.longitude)
            getWeatherInternal(city: city, for: urlString)
        }else {
            let urlString = API.getURLFor(lat: 37.5485, lon: -121.9886)
            getWeatherInternal(city: city, for: urlString)
        }
    }
    
    private func getWeatherInternal(city: String, for urlString: String) {
        NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!, completion: {result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
                break
            case .failure(let err):
                print(err)
            }
        })
    }
    
    
}


