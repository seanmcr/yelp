//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

let RadioOptionCellIdentifier = "RadioOptionCell"
let SwitchCellIdentifier = "SwitchCell"
let ExpandCollapseCellIdentifier = "ExpandCollapseCell"

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:FilterSettings)
}

protocol TableViewExpandableSection: NSObjectProtocol {
    init(parent: TableViewWithExpandableSectionsDelegate, section: Int, selectedValue: Any?)
    var sectionNumber: Int { get }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

protocol TableViewWithExpandableSectionsDelegate: NSObjectProtocol {
    var tableView: UITableView! { get }
    func tableViewExpandableSection(section: TableViewExpandableSection, didExpand value: Bool)
}

class FiltersViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    TableViewWithExpandableSectionsDelegate {
    
    func tableViewExpandableSection(section: TableViewExpandableSection, didExpand value: Bool) {
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: section.sectionNumber), with: UITableViewRowAnimation.automatic)
        tableView.endUpdates()
    }


    var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!

    var filterCategories: [(sectionName: String, sectionHandler: TableViewExpandableSection)] = []
    private var dealsOnlySection: DealsFilterSection?
    private var sortBySection: SortByFilterSection?
    private var distanceSection: DistanceFilterSection?
    private var categoriesSection: CategoriesFilterSection?

    @IBAction func onSearchButton(_ sender: Any) {
        let filterSettings = FilterSettings()
        filterSettings.onlyDeals = dealsOnlySection!.onlyDeals
        filterSettings.sortMode = sortBySection!.selectedSortMode.mode
        filterSettings.distance = distanceSection!.selectedDistance.distance
        filterSettings.categories = Array(categoriesSection!.selectedCategories)
        filterSettings.saveToUserDefaults()
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filterSettings)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let defaultValues = FilterSettings.getFromUserDefaults()
        dealsOnlySection = DealsFilterSection(parent: self, section: 0, selectedValue: defaultValues.onlyDeals)
        sortBySection = SortByFilterSection(parent: self, section: 1, selectedValue: defaultValues.sortMode)
        distanceSection = DistanceFilterSection(parent: self, section: 2, selectedValue: defaultValues.distance)
        categoriesSection = CategoriesFilterSection(parent: self, section: 3, selectedValue: defaultValues.categories)
        filterCategories = [
            (sectionName: "Deals", sectionHandler: dealsOnlySection!),
            (sectionName: "Sort By", sectionHandler: sortBySection!),
            (sectionName: "Distance", sectionHandler: distanceSection!),
            (sectionName: "Categories", sectionHandler: categoriesSection!)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterCategories[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories[section].sectionHandler.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return filterCategories[indexPath.section].sectionHandler.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return filterCategories[indexPath.section].sectionHandler.tableView(tableView, didSelectRowAt: indexPath)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
