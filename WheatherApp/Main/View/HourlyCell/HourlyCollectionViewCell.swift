//
//  HourlyCollectionViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 05/05/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    static let identifier = "HourlyCollectionViewCell"
    
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblTemp:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var uvBackground:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundedCorner()
    }

    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
    
    func configure(with model: Weather) {
        let mvModal = MainViewModel()
        self.lblTemp.text = mvModal.getTempFor(temp: model.temp)
        self.lblTime.text = mvModal.gettimeFor(timestamp: model.dt)
        self.imgWeatherIcon.contentMode = .scaleAspectFit
        self.imgWeatherIcon.image = mvModal.getWeatherIconFor(icon: model.weather.count > 0 ? model.weather[0].icon : "sun.max.fill")
    }
    
    func roundedCorner() {
        //uvBackground.backgroundColor = UIColor.blue
        uvBackground.layer.cornerRadius = 5
        uvBackground.layer.masksToBounds = false
        uvBackground.layer.borderWidth = 1.0
        uvBackground.layer.borderColor = UIColor.white.cgColor
        //uvBackground.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        uvBackground.backgroundColor = UIColor.clear
        
    }

}
