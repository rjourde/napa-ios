//
//  TripViewController.swift
//  napa
//
//  Created by Remy JOURDE on 11/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class TripViewController: UITabBarController {

    var trip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Managing the trip
    
    func setTrip(newTrip: Trip) {
        if self.trip != newTrip {
            self.trip = newTrip
    
            // Update the navigation title
            self.navigationItem.title = self.trip?.name
        }
    }

}
