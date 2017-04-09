//
//  FilterSettings.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/8/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class FilterSettings {
    var onlyDeals: Bool?
    var sortMode: YelpSortMode?
    var categories: [String]?
    var distance: Int?
    
    func saveToUserDefaults(){
        let userDefaults = UserDefaults.standard
        userDefaults.setValuesForKeys([
            "onlyDeals": onlyDeals as Any,
            "sortMode": sortMode as Any,
            "categories": categories as Any,
            "distance": distance as Any
        ])
        userDefaults.synchronize()
    }
    
    static func getFromUserDefaults() -> FilterSettings {
        let filterSettings = FilterSettings()
        let userDefaults = UserDefaults.standard
        filterSettings.onlyDeals = userDefaults.value(forKey: "onlyDeals") as? Bool
        filterSettings.sortMode = userDefaults.value(forKey: "sortMode") as? YelpSortMode
        filterSettings.categories = userDefaults.value(forKey: "categories") as? [String]
        filterSettings.distance = userDefaults.value(forKey: "distance") as? Int
        return filterSettings
    }
}
