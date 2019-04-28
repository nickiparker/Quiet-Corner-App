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
    var imageURL: String
    
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
            "longitude": longitude,
            "imageURL": imageURL
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
        let longitude = dictionary["longitude"] as? String,
        var imageURL = dictionary["imageURL"] as? String ?? "https://static2.bigstockphoto.com/2/6/2/large1500/262292797.jpg" as? String
        
        else { return nil }
        
        if imageURL == "" {
            imageURL = "https://static2.bigstockphoto.com/2/6/2/large1500/262292797.jpg"
        }
        
        self.init(description: description, location: location, id: id, beach: beach, cafe: cafe, trails: trails, gardens: gardens, historical: historical, latitude: latitude, longitude: longitude, imageURL: imageURL)
    }
}

