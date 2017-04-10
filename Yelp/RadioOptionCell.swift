//
//  RadioOptionCell.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class RadioOptionCell: UITableViewCell {

    @IBOutlet weak var border: UIView!
    @IBOutlet weak var checkMarkLabel: UILabel!
    @IBOutlet weak var checkMark: CircularCheckMarkView!
    @IBOutlet weak var expandIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
