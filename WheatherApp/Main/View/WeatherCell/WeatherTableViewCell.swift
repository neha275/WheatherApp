//
//  WeatherTableViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 05/05/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    static let identifier = "WeatherTableViewCell"
    
    @IBOutlet weak var lblday:UILabel!
    @IBOutlet weak var lblhighTemp: UILabel!
    @IBOutlet weak var lbllowTemp: UILabel!
    @IBOutlet weak var imgIcon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configuare(to model: DailyWeather){
        self.lbllowTemp.text = "\(Int(model.temp.min)) ℉"
        self.lblhighTemp.text = "\(Int(model.temp.max)) ℉"
        let mvModel : MainViewModel =  MainViewModel()
        self.lblday.text = mvModel.getDayFor(timestamp: model.dt).uppercased()
        
        imgIcon.image = mvModel.getWeatherIconFor(icon: model.weather.count > 0 ? model.weather[0].icon : "sun.max.fill")
    }
    
}
