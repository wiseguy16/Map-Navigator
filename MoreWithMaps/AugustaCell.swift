//
//  AugustaCell.swift
//  MoreWithMaps
//
//  Created by Gregory Weiss on 7/31/17.
//  Copyright © 2017 gergusa. All rights reserved.
//

import UIKit

class AugustaCell: UITableViewCell {
    
    // These are the beacons!!!!?
    
    @IBOutlet weak var markerImageView: UIImageView!
    
    @IBOutlet weak var markerTitle: UILabel!
    
    @IBOutlet weak var markerDescription: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
