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
        uvBackground.layer.shadowOffset = CGSize(width: 0,height: 0)
        uvBackground.layer.shadowOpacity = 0.3
        uvBackground.layer.shadowColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
    }
    
    func configure(mainViewModel: MainViewModel) {
        lblTodayTemp.text =  mainViewModel.getTempFor(temp: mainViewModel.weather.current.temp)
        lblhumidity.text = mainViewModel.humidity
        lblWindSpeed.text = mainViewModel.windSped
        lblRainChance.text = mainViewModel.rainChance
        
        imgIcon.image =  UIImage(systemName: mainViewModel.weatherIcon)
    }

}
