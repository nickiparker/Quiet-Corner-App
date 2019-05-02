//
//  ItemCell.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 09/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var journeyDistance: UILabel!
    @IBOutlet var journeyTime: UILabel!
    @IBOutlet var locationImage: UIImageView! {
        didSet {
            locationImage.clipsToBounds = true
        }
    }
    //    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var journeyTime: UILabel!
//    @IBOutlet weak var journeyDistance: UILabel!
//    @IBOutlet weak var locationImage: UIImageView!{
//        didSet {
//            locationImage.clipsToBounds = true
//        }
//    }
}

