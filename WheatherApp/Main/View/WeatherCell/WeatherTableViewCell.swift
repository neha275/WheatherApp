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
    @IBOutlet weak var uvBackground:UIView!
    
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
        
        
        let mvModel : MainViewModel =  MainViewModel()
        self.lbllowTemp.text = mvModel.getTempFor(temp: model.temp.min)
        self.lblhighTemp.text = mvModel.getTempFor(temp: model.temp.max)
        self.lblday.text = mvModel.getDayFor(timestamp: model.dt).uppercased()
        imgIcon.image = mvModel.getWeatherIconFor(icon: model.weather.count > 0 ? model.weather[0].icon : "sun.max.fill")
    }
    
}
