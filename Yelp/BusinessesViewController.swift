//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import ARSLineProgress
import CoreLocation

class BusinessesViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate,
    FiltersViewControllerDelegate,
    CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var searchSettings: FilterSettings?
    var searchBar: UISearchBar!
    var locationManager: CLLocationManager!
    
    var latitude: Float?
    var longitude: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchSettings = FilterSettings.getFromUserDefaults()
        
        searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        initializeCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchSettings = FilterSettings.getFromUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavController = segue.destination as! UINavigationController
        let filtersViewController = destinationNavController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    @IBAction func onBarSearchButton(_ sender: Any) {
        searchBarSearchButtonClicked(searchBar)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil) {
            ARSLineProgress.show()
            Business.searchWithTerm(term: searchBar.text!, sort: searchSettings?.sortMode, distance: searchSettings?.distance, categories: searchSettings?.categories, deals: searchSettings?.onlyDeals, completion: { (businesses: [Business]?, error: Error?) -> Void in
                if (error != nil){
                    ARSLineProgress.showFail()
                } else {
                    ARSLineProgress.showSuccess()
                }
                self.businesses = businesses
                self.tableView.reloadData()
            })
        }
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: FilterSettings) {
        searchSettings = filters
        searchBarSearchButtonClicked(navigationItem.titleView as! UISearchBar)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }

    
    func initializeCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        YelpClient.latitude = userLocation.coordinate.latitude
        YelpClient.longitude = userLocation.coordinate.longitude
        searchBarSearchButtonClicked(searchBar)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
