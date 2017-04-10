//
//  ExpandCollapseCell.swift
//  Yelp
//
//  Created by Sean McRoskey on 4/9/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class ExpandCollapseCell: UITableViewCell {

    var showExpand: Bool = true {
        didSet {
            if (showExpand) {
                moreLessLabel.text = "More"
                expandCollapseImage.transform = CGAffineTransform(rotationAngle: 0)
            } else {
                moreLessLabel.text = "Less"
                expandCollapseImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            
        }
    }
    
    @IBOutlet weak var moreLessLabel: UILabel!
    @IBOutlet weak var expandCollapseImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
