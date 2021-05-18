//
//  TodayForecastTableViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 12/05/21.
//

import UIKit

class TodayForecastTableViewCell: UITableViewCell {

    static let identifier = "TodayForecastTableViewCell"
    
    @IBOutlet weak var lblTodayTemp:UILabel!
    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var lblhumidity: UILabel! //viewModel.humidity
    @IBOutlet weak var lblWindSpeed: UILabel! //viewModel.windspeed
    @IBOutlet weak var lblRainChance:UILabel! //viewModel.rainchance
    @IBOutlet weak var uvBackground:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedCorner()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func roundedCorner() {
        uvBackground.layer.cornerRadius = 20
        uvBackground.layer.masksToBounds = false
        uvBackground.layer.borderWidth = 1.0
        uvBackground.layer.borderColor = UIColor.white.cgColor
        uvBackground.layer.shadowOffset = CGSize(width: 0,height: 0)
        uvBackground.layer.shadowOpacity = 0.8
        uvBackground.layer.shadowColor = UIColor.blue.cgColor

       // uvBackground.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    }
    
    func configure(mainViewModel: MainViewModel) {
        lblTodayTemp.text =  mainViewModel.getTempFor(temp: mainViewModel.weather.current.temp)
        lblhumidity.text = mainViewModel.humidity
        lblWindSpeed.text = "\(mainViewModel.windSped)mi/hr"
        lblRainChance.text = mainViewModel.rainChance
        imgIcon.image =  mainViewModel.getWeatherIconFor(icon: mainViewModel.weatherIcon)
    }

}
