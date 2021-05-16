//
//  HourlyTableViewCell.swift
//  WheatherApp
//
//  Created by Neha Gupta on 13/05/21.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    

    var models = [Weather]()
    static let identifier = "HourlyTableViewCell"
    
    @IBOutlet weak var collectionView:UICollectionView!

    static func nib() -> UINib {
            return UINib(nibName: "HourlyTableViewCell",
                         bundle: nil)
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with models: [Weather]) {
        self.models = models
        collectionView.reloadData()
    }
    
    //MARKS: - Collection View -
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor.clear
                return cell
    }
    
}
