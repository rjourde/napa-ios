//
//  TripDigestsViewController.swift
//  napa
//
//  Created by Remy JOURDE on 09/11/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

let TripDigestCellIdentifier = "TripDigestCell"
let ShowMapViewSegueIdentifier = "showMapView"

class TripDigestsViewController: UITableViewController, MapViewControllerDelegate {

    private var tripDigests = []
    
    private var emptyStateView: EmptyStateView?
    private var isMapViewDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // check empty state
        if isTableViewEmpty() {
            showEmptyStateView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == ShowMapViewSegueIdentifier {
            let navigationController = segue.destinationViewController as UINavigationController
            let mapViewController = navigationController.viewControllers[0] as MapViewController
            mapViewController.delegate = self
        }
    }

    // MARK: - UITableView data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDigests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(TripDigestCellIdentifier, forIndexPath: indexPath) as UITableViewCell
    }
    
    // MARK: - UITableViewDelegate
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
    */
    
    // MARK: - MapViewControllerDelegate
    
    func mapViewControllerDidCancel(controller: MapViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mapViewControllerDidDone(controller: MapViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private methods
    
    private func isTableViewEmpty() -> Bool {
        return tripDigests.count == 0
    }
    
    private func showEmptyStateView() {
        if emptyStateView == nil {
            emptyStateView = EmptyStateView(frame: view.frame)
        }
        
        view = emptyStateView!
    }
}
