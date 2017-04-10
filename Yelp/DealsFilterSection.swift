//
//  DealsFilterSection.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

class DealsFilterSection: NSObject, TableViewExpandableSection {
    
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
        cell.toggleSwitch.isOn = onlyDeals
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

