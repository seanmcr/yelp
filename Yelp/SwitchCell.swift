//
//  SwitchCell.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var border: UIView!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        border.layer.cornerRadius = 5
        border.layer.borderWidth = 1
        border.layer.borderColor = UIColor.lightGray.cgColor
    }

    func switchValueChanged(){
        delegate?.switchCell?(switchCell: self, didChangeValue: toggleSwitch.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
