//
//  DistanceFilterSection.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

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
