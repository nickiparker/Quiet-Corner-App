//
//  Filters.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 18/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import Foundation

struct Filters {
    var beach: Bool
    var historical: Bool
    var gardens: Bool
    var trails: Bool
    var cafe: Bool
    
    init(dictionary: [String: Any]) {
        self.beach = dictionary["beach"] as? Bool ?? false
        self.historical = dictionary["historical"] as? Bool ?? false
        self.gardens = dictionary["gardens"] as? Bool ?? false
        self.trails = dictionary["trails"] as? Bool ?? false
        self.cafe = dictionary["cafe"] as? Bool ?? false
    }
}
