//
//  MapViewController.swift
//  napa
//
//  Created by Remy JOURDE on 10/11/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func mapViewControllerDidCancel(controller: MapViewController)
    func mapViewControllerDidDone(controller: MapViewController)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView?
    var overlayView: OverlayView?
    
    private let locationManager = CLLocationManager()
    private var needToCenterMap = true
    
    var delegate: MapViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location manager configuration
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        // map configuration
        if let mapView = self.mapView {
            mapView.showsUserLocation = true
            
            overlayView = OverlayView(frame: mapView.frame)
            view.addSubview(overlayView!)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.mapViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        delegate?.mapViewControllerDidDone(self)
    }
    
    // MARK: - CCLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if let mapView = self.mapView {
            if needToCenterMap == true {
                // center map on user location
                mapView.region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05))
                needToCenterMap = false
            }
        }
    }
}
