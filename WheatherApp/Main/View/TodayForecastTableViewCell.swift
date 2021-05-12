//
//  TodayForecastTableViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 12/05/21.
//

import UIKit

class TodayForecastTableViewCell: UITableViewCell {

    static let identifier = "TodayForecastTableViewCell"
    
    @IBOutlet weak var lbl:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
