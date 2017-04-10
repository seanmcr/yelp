//
//  CategoriesFilterSection.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

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
