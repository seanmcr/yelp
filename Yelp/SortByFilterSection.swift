//
//  SortByFilterSection.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

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
