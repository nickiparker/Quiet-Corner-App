//
//  ItemCell.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 09/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var journeyTime: UILabel!
    @IBOutlet weak var journeyDistance: UILabel!
    @IBOutlet weak var locationImage: UIImageView!{
        didSet {
            locationImage.clipsToBounds = true
        }
    }
}

