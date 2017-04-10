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

class SortByFilterSection: NSObject, TableViewExpandableSection {
    static private let sortModes: [(name: String, mode: YelpSortMode)] = [
        (name: "Best Matched", mode: .bestMatched),
        (name: "Distance", mode: .distance),
        (name: "Highest Rated", mode: .highestRated)
    ]
    private var isExpanded: Bool = false

    var sectionNumber: Int
    var selectedSortMode: (name: String, mode: YelpSortMode)
    weak var delegate: TableViewWithExpandableSectionsDelegate?
    
    required init(parent: TableViewWithExpandableSectionsDelegate, section: Int, selectedValue: Any?) {
        delegate = parent
        sectionNumber = section
        if (selectedValue != nil) {
            let startingSortMode = selectedValue as! YelpSortMode
            switch startingSortMode {
            case .bestMatched:
                selectedSortMode = SortByFilterSection.sortModes[0]
            case .distance:
                selectedSortMode = SortByFilterSection.sortModes[1]
            case .highestRated:
                selectedSortMode = SortByFilterSection.sortModes[2]
            }
        } else {
            selectedSortMode = SortByFilterSection.sortModes[0]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == sectionNumber)
        return isExpanded ? SortByFilterSection.sortModes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioOptionCellIdentifier, for: indexPath) as! RadioOptionCell
        if (isExpanded){
            let sortMode = SortByFilterSection.sortModes[indexPath.row]
            cell.checkMarkLabel.text = sortMode.name
            cell.checkMark.checked = selectedSortMode.mode == sortMode.mode
            cell.checkMark.isHidden = !cell.checkMark.checked
        } else {
            cell.checkMarkLabel.text = selectedSortMode.name
            cell.checkMark.isHidden = true
        }
        cell.expandIcon.isHidden = isExpanded
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isExpanded){
            selectedSortMode = SortByFilterSection.sortModes[indexPath.row]
        }
        isExpanded = !isExpanded
        delegate?.tableViewExpandableSection(section: self, didExpand: isExpanded)
    }
}

class DistanceFilterSection: NSObject, TableViewExpandableSection {
    static private let distanceFilters: [(name: String, distance: Int?)] = [
        (name: "Auto", distance: nil),
        (name: "0.3 miles", distance: 483),
        (name: "1 mile", distance: 1609),
        (name: "5 miles", distance: 8047),
        (name: "25 miles", distance: 40234)
    ]
    private var isExpanded: Bool = false
    
    var sectionNumber: Int
    var selectedDistance: (name: String, distance: Int?)
    weak var delegate: TableViewWithExpandableSectionsDelegate?
    
    required init(parent: TableViewWithExpandableSectionsDelegate, section: Int, selectedValue: Any?) {
        delegate = parent
        sectionNumber = section
        selectedDistance = DistanceFilterSection.distanceFilters[0]
        if (selectedValue != nil) {
            let defaultDistance = selectedValue as! Int
            for distanceFilter in DistanceFilterSection.distanceFilters {
                if (distanceFilter.distance == defaultDistance){
                    selectedDistance = distanceFilter
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == sectionNumber)
        return isExpanded ? DistanceFilterSection.distanceFilters.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RadioOptionCellIdentifier, for: indexPath) as! RadioOptionCell
        if (isExpanded){
            let distanceFilter = DistanceFilterSection.distanceFilters[indexPath.row]
            cell.checkMarkLabel.text = distanceFilter.name
            cell.checkMark.checked = selectedDistance.distance == distanceFilter.distance
            cell.checkMark.isHidden = !cell.checkMark.checked
        } else {
            cell.checkMarkLabel.text = selectedDistance.name
            cell.checkMark.isHidden = true
        }
        cell.expandIcon.isHidden = isExpanded
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isExpanded){
            selectedDistance = DistanceFilterSection.distanceFilters[indexPath.row]
        }
        isExpanded = !isExpanded
        delegate?.tableViewExpandableSection(section: self, didExpand: isExpanded)
    }
}

class CategoriesFilterSection: NSObject, TableViewExpandableSection, SwitchCellDelegate {
    static private let categoryFilters = YelpApi.categories
    
    private var isExpanded: Bool = false
    
    var sectionNumber: Int
    var selectedCategories: Set<String> = []
    weak var delegate: TableViewWithExpandableSectionsDelegate?
    
    required init(parent: TableViewWithExpandableSectionsDelegate, section: Int, selectedValue: Any?) {
        delegate = parent
        sectionNumber = section
        if (selectedValue != nil) {
            let defaultCategories = selectedValue as! [String]
            selectedCategories = Set(defaultCategories)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == sectionNumber)
        return isExpanded
            ? CategoriesFilterSection.categoryFilters.count + 1
            : 6 // In collapsed state, 5 types + 'more' cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberRows = tableView.numberOfRows(inSection: indexPath.section)
        if (indexPath.row == numberRows - 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandCollapseCellIdentifier, for: indexPath) as! ExpandCollapseCell
            cell.showExpand = !isExpanded
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCellIdentifier, for: indexPath) as! SwitchCell
            let categoryFilter = CategoriesFilterSection.categoryFilters[indexPath.row]
            cell.switchLabel.text = categoryFilter.name
            cell.toggleSwitch.isOn = selectedCategories.contains(categoryFilter.code)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let numberRows = tableView.numberOfRows(inSection: indexPath.section)
        if (indexPath.row == numberRows - 1) {
            isExpanded = !isExpanded
        }
        delegate?.tableViewExpandableSection(section: self, didExpand: isExpanded)
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        if let row = delegate!.tableView.indexPath(for: switchCell)?.row {
            let category = CategoriesFilterSection.categoryFilters[row].code
            if (selectedCategories.contains(category)) {
                selectedCategories.remove(category)
            } else {
                selectedCategories.insert(category)
            }
        }
    }
    
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

    var cellSwitchStates: [Int:Bool] = [:]
    
    @IBOutlet weak var tableView: UITableView!

    var filterCategories: [(sectionName: String, sectionHandler: TableViewExpandableSection)] = []
    private var sortBySection: SortByFilterSection?
    private var distanceSection: DistanceFilterSection?
    private var categoriesSection: CategoriesFilterSection?

    @IBAction func onSearchButton(_ sender: Any) {
        let filterSettings = FilterSettings()
        filterSettings.sortMode = sortBySection!.selectedSortMode.mode
        filterSettings.distance = distanceSection!.selectedDistance.distance
        filterSettings.categories = Array(categoriesSection!.selectedCategories)
        filterSettings.saveToUserDefaults()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let defaultValues = FilterSettings.getFromUserDefaults()
        sortBySection = SortByFilterSection(parent: self, section: 0, selectedValue: defaultValues.sortMode)
        distanceSection = DistanceFilterSection(parent: self, section: 1, selectedValue: defaultValues.distance)
        categoriesSection = CategoriesFilterSection(parent: self, section: 2, selectedValue: defaultValues.categories)
        filterCategories = [
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
        // Do any additional setup after loading the view.
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
//        cell.delegate = self
//        cell.toggleSwitch.isOn = cellSwitchStates[indexPath.row] ?? false
//        cell.switchLabel.text = YelpApi.categories[indexPath.row]["name"]
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return filterCategories[indexPath.section].sectionHandler.tableView(tableView, didSelectRowAt: indexPath)
    }

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        if let row = tableView.indexPath(for: switchCell)?.row {
            cellSwitchStates[row] = value
        }
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
