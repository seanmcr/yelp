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

protocol TableViewExpandableSection: NSObjectProtocol {
    init(parent: TableViewWithExpandableSectionsDelegate, section: Int)
    var sectionNumber: Int { get }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

protocol TableViewWithExpandableSectionsDelegate: NSObjectProtocol {
    func tableViewExpandableSection(section: TableViewExpandableSection, didExpand value: Bool)
}

class SortByFilterSection: NSObject, TableViewExpandableSection {
    static private let sortModes: [(name: String, mode: YelpSortMode)] = [
        (name: "Best Matched", mode: .bestMatched),
        (name: "Distance", mode: .distance),
        (name: "Highest Rated", mode: .highestRated)
    ]
    private var isExpanded: Bool = true

    var sectionNumber: Int
    var selectedSortMode: (name: String, mode: YelpSortMode)
    weak var delegate: TableViewWithExpandableSectionsDelegate?
    
    required init(parent: TableViewWithExpandableSectionsDelegate, section: Int) {
        delegate = parent
        sectionNumber = section
        selectedSortMode = SortByFilterSection.sortModes[0]
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

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        filterCategories = [
            (sectionName: "Sort By", sectionHandler: SortByFilterSection(parent: self, section: 0))
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
