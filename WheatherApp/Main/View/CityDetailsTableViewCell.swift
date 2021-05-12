//
//  CityDetailsTableViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 12/05/21.
//

import UIKit

class CityDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCityName:UILabel!
    @IBOutlet weak var lblCurrentDate:UILabel!
    
    static let identifier = "CityDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
