//
//  Location.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 09/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import Foundation

struct Location {
//    var attractions: Bool
//    var beach: Bool
//    var cafe: Bool
    var description: String
    var location: String
    var id: String
    
    var dictionary: [String: Any] {
        return[
//            "attractions": attractions,
//            "beach": beach,
//            "cafe": cafe,
            "description": description,
            "location": location
        ]
    }
}

extension Location {
    init?(dictionary: [String : Any], id: String) {
//        guard let attractions = dictionary["attractions"] as? Bool,
//        let beach = dictionary["beach"] as? Bool,
//        let cafe = dictionary["cafe"] as? Bool,
       guard let description = dictionary["description"] as? String,
        let location = dictionary["location"] as? String
            else { return nil }
        
        self.init(description: description, location: location, id: id)
        
    }
}

//attractions: attractions, beach: beach, cafe: cafe,
