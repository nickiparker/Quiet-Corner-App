//
//  Location.swift
//  Quiet-Corner
//
//  Created by NICKI PARKER on 09/04/2019.
//  Copyright © 2019 Nickiparker. All rights reserved.
//

import Foundation

struct Location {
    var description: String
    var location: String
    var id: String
    var beach: Bool
    var cafe: Bool
    var trails: Bool
    var gardens: Bool
    var historical: Bool
    var latitude: String
    var longitude: String
    
    var dictionary: [String: Any] {
        return[
            "description": description,
            "location": location,
            "beach": beach,
            "cafe": cafe,
            "trails": trails,
            "gardens": gardens,
            "historical": historical,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
}

extension Location {
    init?(dictionary: [String : Any], id: String) {
        guard let description = dictionary["description"] as? String,
        let location = dictionary["location"] as? String,
        let beach = dictionary["beach"] as? Bool,
        let cafe = dictionary["cafe"] as? Bool,
        let trails = dictionary["trails"] as? Bool,
        let gardens = dictionary["gardens"] as? Bool,
        let historical = dictionary["historical"] as? Bool,
        let latitude = dictionary["latitude"] as? String,
        let longitude = dictionary["longitude"] as? String
        else { return nil }
        
        self.init(description: description, location: location, id: id, beach: beach, cafe: cafe, trails: trails, gardens: gardens, historical: historical, latitude: latitude, longitude: longitude)
    }
}

