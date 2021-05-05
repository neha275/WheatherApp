//
//  HourlyCollectionViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 05/05/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    static let identifier = "HourlyCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
    }
}
