//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import ARSLineProgress

class BusinessesViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchBarDelegate,
    FiltersViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]!
    var searchSettings: FilterSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchSettings = FilterSettings.getFromUserDefaults()
        
        let searchBar = UISearchBar()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        Business.searchWithTerm(term: "", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData()
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchSettings = FilterSettings.getFromUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavController = segue.destination as! UINavigationController
        let filtersViewController = destinationNavController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != nil) {
            ARSLineProgress.show()
            Business.searchWithTerm(term: searchBar.text!, sort: searchSettings?.sortMode, distance: searchSettings?.distance, categories: searchSettings?.categories, deals: searchSettings?.onlyDeals, completion: { (businesses: [Business]?, error: Error?) -> Void in
                if (error != nil){
                    ARSLineProgress.showFail()
                } else {
                    ARSLineProgress.hide()
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
