//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Jared Annibale on 3/19/17.
//  Copyright © 2017 Jared Annibale. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    
    var currentPage = 0
    var locationsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       locationLabel.text = locationsArray[currentPage]
    }

   
}
