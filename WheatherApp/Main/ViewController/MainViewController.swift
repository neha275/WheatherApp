//
//  MainViewController.swift
//  WheatherApp
//
//  Created by Neha Gupta on 03/05/21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var table:UITableView!
    
    var modals = [Wheather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(HourlyCollectionViewCell.nib(), forCellReuseIdentifier: HourlyCollectionViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
