//
//  DealsFilterSection.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

class DealsFilterSection: NSObject, TableViewExpandableSection, SwitchCellDelegate {
    
    var onlyDeals: Bool!
    
    var sectionNumber: Int
    weak var delegate: TableViewWithExpandableSectionsDelegate?
    
    required init(parent: TableViewWithExpandableSectionsDelegate, section: Int, selectedValue: Any?) {
        delegate = parent
        sectionNumber = section
        onlyDeals = selectedValue as? Bool ?? false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == sectionNumber)
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCellIdentifier, for: indexPath) as! SwitchCell
        cell.switchLabel.text = "Offering a Deal"
        cell.toggleSwitch.isOn = onlyDeals
        cell.delegate = self
        return cell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        onlyDeals = value
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

