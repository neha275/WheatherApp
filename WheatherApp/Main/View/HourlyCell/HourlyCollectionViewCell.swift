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
        self.imgWeatherIcon.image = UIImage(named: "sun.max.fill")
    }
    
    func roundedCorner() {
        //uvBackground.backgroundColor = UIColor.blue
        uvBackground.layer.cornerRadius = 20
        uvBackground.layer.masksToBounds = false
        uvBackground.layer.shadowOffset = CGSize(width: 0,height: 0)
        uvBackground.layer.shadowOpacity = 0.3
        uvBackground.layer.shadowColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
    }

}
